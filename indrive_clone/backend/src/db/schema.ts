import { sql } from 'drizzle-orm';
import {
  boolean,
  geometry,
  index,
  integer,
  jsonb,
  pgEnum,
  pgTable,
  real,
  text,
  timestamp,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';

/* ------------------------------------------------------------------ */
/* Enums                                                               */
/* ------------------------------------------------------------------ */

/** The 4 InDrive services. */
export const serviceTypeEnum = pgEnum('service_type', ['city', 'intercity', 'courier', 'freight']);

/** Vehicle classes used in InDrive Pakistan. */
export const vehicleTypeEnum = pgEnum('vehicle_type', [
  'moto', // bike
  'rickshaw', // auto rickshaw
  'mini', // small car (Ride Mini)
  'ac', // car with A/C (Ride A/C)
  'comfort', // newer bigger car
  'loader', // Suzuki pickup / Shehzore (freight)
  'truck', // truck (freight)
]);

export const driverStatusEnum = pgEnum('driver_status', ['pending', 'approved', 'rejected', 'blocked']);

/**
 * Ride life cycle:
 * searching -> accepted -> arrived -> in_progress -> completed
 *      \-> expired          \-> cancelled (any time before completed)
 */
export const rideStatusEnum = pgEnum('ride_status', [
  'searching',
  'accepted',
  'arrived',
  'in_progress',
  'completed',
  'cancelled',
  'expired',
]);

export const offerStatusEnum = pgEnum('offer_status', ['pending', 'accepted', 'rejected', 'expired', 'withdrawn']);
export const actorEnum = pgEnum('actor', ['passenger', 'driver', 'system']);
export const paymentMethodEnum = pgEnum('payment_method', ['cash']);
export const walletTxTypeEnum = pgEnum('wallet_tx_type', ['bonus', 'commission', 'topup', 'adjustment']);

const point = (name: string) => geometry(name, { type: 'point', mode: 'xy', srid: 4326 });
const createdAt = () => timestamp('created_at', { withTimezone: true }).notNull().defaultNow();

/* ------------------------------------------------------------------ */
/* Tables                                                              */
/* ------------------------------------------------------------------ */

export const users = pgTable('users', {
  id: uuid('id').primaryKey().defaultRandom(),
  phone: text('phone').notNull().unique(),
  name: text('name'),
  email: text('email'),
  photoUrl: text('photo_url'),
  language: text('language').notNull().default('en'),
  /** Rating that drivers give to this user as a passenger. */
  rating: real('rating').notNull().default(5),
  ratingCount: integer('rating_count').notNull().default(0),
  isBlocked: boolean('is_blocked').notNull().default(false),
  /** Firebase Cloud Messaging token for push notifications (optional). */
  fcmToken: text('fcm_token'),
  createdAt: createdAt(),
  updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
});

export const refreshTokens = pgTable(
  'refresh_tokens',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    tokenHash: text('token_hash').notNull().unique(),
    expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
    revokedAt: timestamp('revoked_at', { withTimezone: true }),
    createdAt: createdAt(),
  },
  (t) => [index('refresh_tokens_user_idx').on(t.userId)],
);

export type DriverDocs = {
  selfie?: string;
  cnicFront?: string;
  cnicBack?: string;
  license?: string;
  vehicle?: string;
};

export const drivers = pgTable(
  'drivers',
  {
    userId: uuid('user_id')
      .primaryKey()
      .references(() => users.id, { onDelete: 'cascade' }),
    status: driverStatusEnum('status').notNull().default('pending'),
    rejectionReason: text('rejection_reason'),
    cnicNumber: text('cnic_number').notNull(),
    licenseNumber: text('license_number').notNull(),
    vehicleType: vehicleTypeEnum('vehicle_type').notNull(),
    vehicleMake: text('vehicle_make').notNull(),
    vehicleModel: text('vehicle_model').notNull(),
    vehicleColor: text('vehicle_color').notNull(),
    vehicleYear: integer('vehicle_year'),
    plateNumber: text('plate_number').notNull(),
    /** Which services this driver wants requests for. */
    services: serviceTypeEnum('services').array().notNull().default(sql`ARRAY['city']::service_type[]`),
    docs: jsonb('docs').$type<DriverDocs>().notNull().default({}),
    /** Rating that passengers give to this driver. */
    rating: real('rating').notNull().default(5),
    ratingCount: integer('rating_count').notNull().default(0),
    /** Wallet balance in PKR. Commission is taken from here. */
    balance: integer('balance').notNull().default(0),
    isOnline: boolean('is_online').notNull().default(false),
    lastLocation: point('last_location'),
    lastHeading: real('last_heading'),
    lastSeenAt: timestamp('last_seen_at', { withTimezone: true }),
    createdAt: createdAt(),
    approvedAt: timestamp('approved_at', { withTimezone: true }),
  },
  (t) => [
    uniqueIndex('drivers_plate_idx').on(t.plateNumber),
    uniqueIndex('drivers_cnic_idx').on(t.cnicNumber),
    // Index on geography so "within X meters" queries are fast.
    index('drivers_location_gist').using('gist', sql`(${t.lastLocation}::geography)`),
  ],
);

export type RideDetails = {
  // Courier
  packageDescription?: string;
  receiverName?: string;
  receiverPhone?: string;
  // Intercity
  departureAt?: string;
  seats?: number;
  sharedRide?: boolean;
  // Freight
  cargoDescription?: string;
  needLoaders?: boolean;
  // City ride options
  childSeat?: boolean;
  withPet?: boolean;
};

export const rides = pgTable(
  'rides',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    passengerId: uuid('passenger_id')
      .notNull()
      .references(() => users.id),
    driverId: uuid('driver_id').references(() => users.id),
    serviceType: serviceTypeEnum('service_type').notNull().default('city'),
    vehicleType: vehicleTypeEnum('vehicle_type').notNull(),
    status: rideStatusEnum('status').notNull().default('searching'),

    pickup: point('pickup').notNull(),
    pickupAddress: text('pickup_address').notNull(),
    dropoff: point('dropoff').notNull(),
    dropoffAddress: text('dropoff_address').notNull(),
    distanceM: integer('distance_m').notNull(),
    durationS: integer('duration_s').notNull(),
    /** Encoded polyline of the route (Google polyline format). */
    routePolyline: text('route_polyline'),

    // ---- Price (InDrive: passenger offers a price, drivers can accept or counter) ----
    recommendedFare: integer('recommended_fare').notNull(),
    minFare: integer('min_fare').notNull(),
    offeredFare: integer('offered_fare').notNull(),
    finalFare: integer('final_fare'),
    commission: integer('commission'),
    paymentMethod: paymentMethodEnum('payment_method').notNull().default('cash'),
    comment: text('comment'),
    details: jsonb('details').$type<RideDetails>().notNull().default({}),

    // ---- Matching ----
    searchRadiusM: integer('search_radius_m').notNull(),
    expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),

    // ---- Timeline ----
    createdAt: createdAt(),
    acceptedAt: timestamp('accepted_at', { withTimezone: true }),
    arrivedAt: timestamp('arrived_at', { withTimezone: true }),
    startedAt: timestamp('started_at', { withTimezone: true }),
    completedAt: timestamp('completed_at', { withTimezone: true }),
    cancelledAt: timestamp('cancelled_at', { withTimezone: true }),
    cancelledBy: actorEnum('cancelled_by'),
    cancelReason: text('cancel_reason'),

    // ---- Ratings (both sides rate each other) ----
    driverStars: integer('driver_stars'), // given by passenger to driver
    driverReview: text('driver_review'),
    passengerStars: integer('passenger_stars'), // given by driver to passenger
    passengerReview: text('passenger_review'),
  },
  (t) => [
    index('rides_pickup_gist').using('gist', sql`(${t.pickup}::geography)`),
    index('rides_status_idx').on(t.status),
    index('rides_passenger_idx').on(t.passengerId, t.createdAt),
    index('rides_driver_idx').on(t.driverId, t.createdAt),
    // A passenger can only have one active ride at a time.
    uniqueIndex('rides_one_active_per_passenger')
      .on(t.passengerId)
      .where(sql`status in ('searching','accepted','arrived','in_progress')`),
    // A driver can only have one active ride at a time.
    uniqueIndex('rides_one_active_per_driver')
      .on(t.driverId)
      .where(sql`status in ('accepted','arrived','in_progress')`),
  ],
);

export const rideOffers = pgTable(
  'ride_offers',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    rideId: uuid('ride_id')
      .notNull()
      .references(() => rides.id, { onDelete: 'cascade' }),
    driverId: uuid('driver_id')
      .notNull()
      .references(() => users.id),
    price: integer('price').notNull(),
    etaSec: integer('eta_sec').notNull(),
    distanceM: integer('distance_m').notNull(),
    status: offerStatusEnum('status').notNull().default('pending'),
    createdAt: createdAt(),
    expiresAt: timestamp('expires_at', { withTimezone: true }).notNull(),
  },
  (t) => [uniqueIndex('ride_offers_ride_driver_idx').on(t.rideId, t.driverId)],
);

export const messages = pgTable(
  'messages',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    rideId: uuid('ride_id')
      .notNull()
      .references(() => rides.id, { onDelete: 'cascade' }),
    senderId: uuid('sender_id')
      .notNull()
      .references(() => users.id),
    body: text('body').notNull(),
    createdAt: createdAt(),
  },
  (t) => [index('messages_ride_idx').on(t.rideId, t.createdAt)],
);

export const savedPlaces = pgTable(
  'saved_places',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    label: text('label').notNull(), // home | work | other
    name: text('name').notNull(),
    address: text('address').notNull(),
    location: point('location').notNull(),
    createdAt: createdAt(),
  },
  (t) => [index('saved_places_user_idx').on(t.userId)],
);

export const walletTransactions = pgTable(
  'wallet_transactions',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    driverId: uuid('driver_id')
      .notNull()
      .references(() => drivers.userId, { onDelete: 'cascade' }),
    amount: integer('amount').notNull(), // + adds money, - takes money
    type: walletTxTypeEnum('type').notNull(),
    rideId: uuid('ride_id').references(() => rides.id),
    note: text('note'),
    createdAt: createdAt(),
  },
  (t) => [index('wallet_tx_driver_idx').on(t.driverId, t.createdAt)],
);

export const ticketCategoryEnum = pgEnum('ticket_category', [
  'lost_item',
  'driver_behaviour',
  'passenger_behaviour',
  'fare_issue',
  'safety',
  'app_problem',
  'account',
  'other',
]);
export const ticketStatusEnum = pgEnum('ticket_status', ['open', 'answered', 'closed']);

/** "Report a problem" / "I lost an item" / help requests. Answered from the admin page. */
export const supportTickets = pgTable(
  'support_tickets',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    rideId: uuid('ride_id').references(() => rides.id),
    category: ticketCategoryEnum('category').notNull(),
    message: text('message').notNull(),
    status: ticketStatusEnum('status').notNull().default('open'),
    adminReply: text('admin_reply'),
    createdAt: createdAt(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (t) => [index('support_tickets_user_idx').on(t.userId, t.createdAt)],
);

export const sosAlerts = pgTable('sos_alerts', {
  id: uuid('id').primaryKey().defaultRandom(),
  rideId: uuid('ride_id').references(() => rides.id),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id),
  location: point('location'),
  resolved: boolean('resolved').notNull().default(false),
  createdAt: createdAt(),
});

export type User = typeof users.$inferSelect;
export type Driver = typeof drivers.$inferSelect;
export type Ride = typeof rides.$inferSelect;
export type RideOffer = typeof rideOffers.$inferSelect;
export type ServiceType = (typeof serviceTypeEnum.enumValues)[number];
export type VehicleType = (typeof vehicleTypeEnum.enumValues)[number];
export type RideStatus = (typeof rideStatusEnum.enumValues)[number];

export const ACTIVE_RIDE_STATUSES: RideStatus[] = ['searching', 'accepted', 'arrived', 'in_progress'];
export const ASSIGNED_RIDE_STATUSES: RideStatus[] = ['accepted', 'arrived', 'in_progress'];
