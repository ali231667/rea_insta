import { env } from '../../config/env.js';
import { CITY_SPEED_MPS, ROAD_FACTOR, distanceM, encodePolyline, type LatLng } from '../../lib/geo.js';
import { logger } from '../../lib/logger.js';
import { redis } from '../../lib/redis.js';

/**
 * Map services (routes, address search, reverse geocoding).
 *
 * - If GOOGLE_MAPS_API_KEY is set we use Google Routes API + Places API (what InDrive uses).
 * - Otherwise we use free OpenStreetMap services: OSRM (routes) and Nominatim (addresses).
 * - If the internet service fails we still return a straight-line estimate, so the app keeps working.
 */

export type Route = { distanceM: number; durationS: number; polyline: string; source: 'google' | 'osrm' | 'estimate' };
export type Place = { name: string; address: string; lat: number; lng: number };

const USER_AGENT = 'InDriveClone-StudentProject/1.0';
const TIMEOUT_MS = 6000;

async function getJson<T>(url: string, init?: RequestInit): Promise<T> {
  const res = await fetch(url, {
    ...init,
    headers: { 'User-Agent': USER_AGENT, Accept: 'application/json', ...(init?.headers ?? {}) },
    signal: AbortSignal.timeout(TIMEOUT_MS),
  });
  if (!res.ok) throw new Error(`HTTP ${res.status} from ${new URL(url).host}`);
  return (await res.json()) as T;
}

/** Cache answers in Redis so we do not call the map service again for the same thing. */
async function cached<T>(key: string, ttlSec: number, fn: () => Promise<T>): Promise<T> {
  const hit = await redis.get(key);
  if (hit) return JSON.parse(hit) as T;
  const value = await fn();
  await redis.set(key, JSON.stringify(value), 'EX', ttlSec);
  return value;
}

const r5 = (n: number) => n.toFixed(5);

/**
 * The free Nominatim server allows about 1 request per second.
 * We wait our turn (shared by all users of this server) so we are not blocked with HTTP 429.
 */
let nominatimNext = 0;
async function nominatimTurn() {
  const now = Date.now();
  const wait = Math.max(0, nominatimNext - now);
  nominatimNext = Math.max(now, nominatimNext) + 1100;
  if (wait > 3000) throw new Error('Nominatim busy'); // too many waiting: use the fallback now
  if (wait > 0) await new Promise((r) => setTimeout(r, wait));
}

/** Photon (komoot) is a second free OpenStreetMap search, used when Nominatim fails. */
type PhotonFeature = {
  properties: { name?: string; street?: string; housenumber?: string; district?: string; locality?: string; city?: string; state?: string; country?: string };
  geometry: { coordinates: [number, number] };
};
const PAKISTAN_BBOX = '60.87,23.63,77.84,37.08';

function photonPlace(f: PhotonFeature): Place {
  const p = f.properties;
  const street = [p.housenumber, p.street].filter(Boolean).join(' ');
  const name = p.name || street || p.district || p.city || 'Place';
  const address = [p.name !== street ? street : null, p.locality, p.district, p.city, p.state, p.country].filter((x, i, a) => x && a.indexOf(x) === i).join(', ');
  return { name, address: address || name, lat: f.geometry.coordinates[1], lng: f.geometry.coordinates[0] };
}

async function photonSearch(q: string, near?: LatLng): Promise<Place[]> {
  const params = new URLSearchParams({ q, limit: '8', lang: 'en', bbox: PAKISTAN_BBOX });
  if (near) {
    params.set('lat', String(near.lat));
    params.set('lon', String(near.lng));
  }
  const data = await getJson<{ features: PhotonFeature[] }>(`https://photon.komoot.io/api/?${params}`);
  return data.features.map(photonPlace);
}

async function photonReverse(p: LatLng): Promise<Place | null> {
  const data = await getJson<{ features: PhotonFeature[] }>(`https://photon.komoot.io/reverse?lat=${p.lat}&lon=${p.lng}&lang=en`);
  const f = data.features[0];
  if (!f) return null;
  const place = photonPlace(f);
  const pr = f.properties;
  const area = pr.district || pr.locality || pr.city;
  return { ...place, name: pr.street ? `${pr.street}${area ? `, ${area}` : ''}` : place.name, ...p };
}

/* ------------------------------ Route ------------------------------ */

export function estimateRoute(from: LatLng, to: LatLng): Route {
  const d = Math.round(distanceM(from, to) * ROAD_FACTOR);
  return { distanceM: d, durationS: Math.max(60, Math.round(d / CITY_SPEED_MPS)), polyline: encodePolyline([from, to]), source: 'estimate' };
}

async function googleRoute(from: LatLng, to: LatLng): Promise<Route> {
  type Res = { routes?: { distanceMeters: number; duration: string; polyline: { encodedPolyline: string } }[] };
  const body = {
    origin: { location: { latLng: { latitude: from.lat, longitude: from.lng } } },
    destination: { location: { latLng: { latitude: to.lat, longitude: to.lng } } },
    travelMode: 'DRIVE',
    routingPreference: 'TRAFFIC_AWARE',
  };
  const data = await getJson<Res>('https://routes.googleapis.com/directions/v2:computeRoutes', {
    method: 'POST',
    body: JSON.stringify(body),
    headers: {
      'Content-Type': 'application/json',
      'X-Goog-Api-Key': env.maps.googleKey!,
      'X-Goog-FieldMask': 'routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline',
    },
  });
  const r = data.routes?.[0];
  if (!r) throw new Error('No route');
  return { distanceM: r.distanceMeters, durationS: parseInt(r.duration, 10), polyline: r.polyline.encodedPolyline, source: 'google' };
}

async function osrmRoute(from: LatLng, to: LatLng): Promise<Route> {
  type Res = { code: string; routes?: { distance: number; duration: number; geometry: string }[] };
  const url = `${env.maps.osrmUrl}/route/v1/driving/${from.lng},${from.lat};${to.lng},${to.lat}?overview=full&geometries=polyline`;
  const data = await getJson<Res>(url);
  const r = data.routes?.[0];
  if (data.code !== 'Ok' || !r) throw new Error(`OSRM: ${data.code}`);
  // OSRM gives free-flow time. Pakistani city traffic is slower, so add 30%.
  return { distanceM: Math.round(r.distance), durationS: Math.round(r.duration * 1.3), polyline: r.geometry, source: 'osrm' };
}

export async function getRoute(from: LatLng, to: LatLng): Promise<Route> {
  const key = `route:${r5(from.lat)},${r5(from.lng)}:${r5(to.lat)},${r5(to.lng)}`;
  try {
    return await cached(key, 600, () => (env.maps.googleKey ? googleRoute(from, to) : osrmRoute(from, to)));
  } catch (err) {
    logger.warn({ err: (err as Error).message }, 'Routing service failed, using straight-line estimate');
    return estimateRoute(from, to);
  }
}

/* ------------------------------ Search ------------------------------ */

export async function searchPlaces(query: string, near?: LatLng): Promise<Place[]> {
  const q = query.trim();
  if (q.length < 2) return [];
  const key = `search:${q.toLowerCase()}:${near ? `${near.lat.toFixed(2)},${near.lng.toFixed(2)}` : ''}`;
  try {
    return await cached(key, 3600, async () => {
      if (env.maps.googleKey) {
        type Res = { places?: { displayName?: { text: string }; formattedAddress: string; location: { latitude: number; longitude: number } }[] };
        const data = await getJson<Res>('https://places.googleapis.com/v1/places:searchText', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': env.maps.googleKey,
            'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.location',
          },
          body: JSON.stringify({
            textQuery: q,
            regionCode: 'PK',
            ...(near ? { locationBias: { circle: { center: { latitude: near.lat, longitude: near.lng }, radius: 50000 } } } : {}),
          }),
        });
        return (data.places ?? []).map((p) => ({
          name: p.displayName?.text ?? p.formattedAddress,
          address: p.formattedAddress,
          lat: p.location.latitude,
          lng: p.location.longitude,
        }));
      }
      type NRes = { name?: string; display_name: string; lat: string; lon: string }[];
      const params = new URLSearchParams({ q, format: 'jsonv2', countrycodes: 'pk', limit: '8', 'accept-language': 'en' });
      if (near) {
        // Prefer results around the user (about 50 km box)
        params.set('viewbox', `${near.lng - 0.5},${near.lat + 0.5},${near.lng + 0.5},${near.lat - 0.5}`);
      }
      let data: NRes;
      try {
        await nominatimTurn();
        data = await getJson<NRes>(`${env.maps.nominatimUrl}/search?${params}`);
      } catch (err) {
        logger.warn({ err: (err as Error).message }, 'Nominatim search failed, using Photon');
        return await photonSearch(q, near);
      }
      return data.map((p) => ({
        name: p.name || p.display_name.split(',')[0]!,
        address: p.display_name,
        lat: Number(p.lat),
        lng: Number(p.lon),
      }));
    });
  } catch (err) {
    logger.warn({ err: (err as Error).message }, 'Place search failed');
    return [];
  }
}

/* -------------------------- Reverse geocode -------------------------- */

export async function reverseGeocode(p: LatLng): Promise<Place> {
  const fallback: Place = { name: `${p.lat.toFixed(5)}, ${p.lng.toFixed(5)}`, address: 'Pinned location', ...p };
  const key = `rev:${p.lat.toFixed(4)},${p.lng.toFixed(4)}`;
  try {
    return await cached(key, 86400, async () => {
      if (env.maps.googleKey) {
        type Res = { results: { formatted_address: string; address_components: { long_name: string; types: string[] }[] }[] };
        const data = await getJson<Res>(
          `https://maps.googleapis.com/maps/api/geocode/json?latlng=${p.lat},${p.lng}&key=${env.maps.googleKey}`,
        );
        const r = data.results[0];
        if (!r) return fallback;
        const route = r.address_components.find((c) => c.types.includes('route'))?.long_name;
        return { name: route ?? r.formatted_address.split(',')[0]!, address: r.formatted_address, ...p };
      }
      type NRes = { display_name?: string; name?: string; address?: Record<string, string> };
      let data: NRes;
      try {
        await nominatimTurn();
        data = await getJson<NRes>(`${env.maps.nominatimUrl}/reverse?format=jsonv2&lat=${p.lat}&lon=${p.lng}&zoom=18&accept-language=en`);
      } catch (err) {
        logger.warn({ err: (err as Error).message }, 'Nominatim reverse failed, using Photon');
        return (await photonReverse(p)) ?? fallback;
      }
      if (!data.display_name) return fallback;
      const a = data.address ?? {};
      const name = data.name || a.road || a.neighbourhood || a.suburb || data.display_name.split(',')[0]!;
      const area = a.suburb || a.neighbourhood || a.city_district || a.city || a.town || '';
      return { name: area && area !== name ? `${name}, ${area}` : name, address: data.display_name, ...p };
    });
  } catch (err) {
    logger.warn({ err: (err as Error).message }, 'Reverse geocode failed');
    return fallback;
  }
}
