import type { ServiceType, VehicleType } from '../../db/schema.js';

/**
 * Fare rules in PKR.
 *
 * InDrive does not force a price. It shows a "recommended fare" and a minimum fare.
 * The passenger can offer any price above the minimum, and drivers accept it or send a higher counter-offer.
 */
type Tariff = { base: number; perKm: number; perMin: number; min: number };

export const TARIFFS: Record<VehicleType, Tariff> = {
  moto: { base: 50, perKm: 20, perMin: 2, min: 100 },
  rickshaw: { base: 70, perKm: 30, perMin: 3, min: 150 },
  mini: { base: 100, perKm: 42, perMin: 5, min: 250 },
  ac: { base: 130, perKm: 50, perMin: 6, min: 300 },
  comfort: { base: 180, perKm: 65, perMin: 8, min: 400 },
  loader: { base: 600, perKm: 90, perMin: 5, min: 1200 },
  truck: { base: 1500, perKm: 160, perMin: 8, min: 3000 },
};

/** Which vehicles can be chosen for each service. */
export const SERVICE_VEHICLES: Record<ServiceType, VehicleType[]> = {
  city: ['moto', 'rickshaw', 'mini', 'ac', 'comfort'],
  courier: ['moto', 'mini'],
  intercity: ['mini', 'ac', 'comfort'],
  freight: ['loader', 'truck'],
};

export const VEHICLE_LABELS: Record<VehicleType, string> = {
  moto: 'Moto',
  rickshaw: 'Rickshaw',
  mini: 'Ride Mini',
  ac: 'Ride A/C',
  comfort: 'Comfort',
  loader: 'Loader',
  truck: 'Truck',
};

const round10 = (n: number) => Math.round(n / 10) * 10;

export type FareQuote = { vehicleType: VehicleType; label: string; recommendedFare: number; minFare: number; maxFare: number };

export function quoteFare(service: ServiceType, vehicle: VehicleType, distanceM: number, durationS: number): FareQuote {
  const t = TARIFFS[vehicle];
  const km = distanceM / 1000;
  const min = durationS / 60;

  let perKm = t.perKm;
  let base = t.base;
  let minFare = t.min;

  if (service === 'intercity') {
    // Long trips: lower price per km, no time charge in traffic.
    perKm = t.perKm * 0.6;
    minFare = Math.max(1500, t.min * 4);
  } else if (service === 'courier') {
    base += 30; // handling the parcel
    minFare = t.min + 50;
  }

  const timeCost = service === 'intercity' ? 0 : t.perMin * min;
  const recommended = Math.max(minFare, round10(base + perKm * km + timeCost));
  return {
    vehicleType: vehicle,
    label: VEHICLE_LABELS[vehicle],
    recommendedFare: recommended,
    minFare: round10(minFare),
    // Stop silly prices (typing mistakes).
    maxFare: round10(recommended * 5),
  };
}

export function quoteAll(service: ServiceType, distanceM: number, durationS: number): FareQuote[] {
  return SERVICE_VEHICLES[service].map((v) => quoteFare(service, v, distanceM, durationS));
}

export const commissionFor = (fare: number, rate: number) => Math.round(fare * rate);
