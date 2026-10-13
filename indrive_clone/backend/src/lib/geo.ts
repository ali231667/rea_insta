export type LatLng = { lat: number; lng: number };

const R = 6_371_000; // earth radius in meters
const rad = (d: number) => (d * Math.PI) / 180;

/** Straight-line distance between two points in meters (haversine formula). */
export function distanceM(a: LatLng, b: LatLng): number {
  const dLat = rad(b.lat - a.lat);
  const dLng = rad(b.lng - a.lng);
  const h = Math.sin(dLat / 2) ** 2 + Math.cos(rad(a.lat)) * Math.cos(rad(b.lat)) * Math.sin(dLng / 2) ** 2;
  return 2 * R * Math.asin(Math.sqrt(h));
}

/** Direction from a to b in degrees (0 = north, 90 = east). */
export function bearing(a: LatLng, b: LatLng): number {
  const y = Math.sin(rad(b.lng - a.lng)) * Math.cos(rad(b.lat));
  const x =
    Math.cos(rad(a.lat)) * Math.sin(rad(b.lat)) - Math.sin(rad(a.lat)) * Math.cos(rad(b.lat)) * Math.cos(rad(b.lng - a.lng));
  return ((Math.atan2(y, x) * 180) / Math.PI + 360) % 360;
}

/** Roads are not straight. Multiply straight distance by this to guess road distance. */
export const ROAD_FACTOR = 1.35;
/** Average city speed in Pakistan traffic (m/s) ~ 22 km/h. */
export const CITY_SPEED_MPS = 22 / 3.6;

/** Rough time for a driver to reach a point when we have no routing service. */
export function estimateEtaSec(from: LatLng, to: LatLng): number {
  return Math.max(60, Math.round((distanceM(from, to) * ROAD_FACTOR) / CITY_SPEED_MPS));
}

/** Converts a drizzle {x,y} point to {lat,lng}. */
export const fromXY = (p: { x: number; y: number }): LatLng => ({ lat: p.y, lng: p.x });
/** Converts {lat,lng} to a drizzle {x,y} point (x = longitude). */
export const toXY = (p: LatLng) => ({ x: p.lng, y: p.lat });

/** Google encoded polyline (used by Google + OSRM). */
export function encodePolyline(points: LatLng[]): string {
  let lastLat = 0;
  let lastLng = 0;
  let out = '';
  const enc = (v: number) => {
    let n = v < 0 ? ~(v << 1) : v << 1;
    let s = '';
    while (n >= 0x20) {
      s += String.fromCharCode((0x20 | (n & 0x1f)) + 63);
      n >>= 5;
    }
    return s + String.fromCharCode(n + 63);
  };
  for (const p of points) {
    const lat = Math.round(p.lat * 1e5);
    const lng = Math.round(p.lng * 1e5);
    out += enc(lat - lastLat) + enc(lng - lastLng);
    lastLat = lat;
    lastLng = lng;
  }
  return out;
}

export function decodePolyline(str: string): LatLng[] {
  const points: LatLng[] = [];
  let index = 0;
  let lat = 0;
  let lng = 0;
  const next = () => {
    let result = 0;
    let shift = 0;
    let b: number;
    do {
      b = str.charCodeAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    return result & 1 ? ~(result >> 1) : result >> 1;
  };
  while (index < str.length) {
    lat += next();
    lng += next();
    points.push({ lat: lat / 1e5, lng: lng / 1e5 });
  }
  return points;
}
