CREATE TYPE "public"."actor" AS ENUM('passenger', 'driver', 'system');--> statement-breakpoint
CREATE TYPE "public"."driver_status" AS ENUM('pending', 'approved', 'rejected', 'blocked');--> statement-breakpoint
CREATE TYPE "public"."offer_status" AS ENUM('pending', 'accepted', 'rejected', 'expired', 'withdrawn');--> statement-breakpoint
CREATE TYPE "public"."payment_method" AS ENUM('cash');--> statement-breakpoint
CREATE TYPE "public"."ride_status" AS ENUM('searching', 'accepted', 'arrived', 'in_progress', 'completed', 'cancelled', 'expired');--> statement-breakpoint
CREATE TYPE "public"."service_type" AS ENUM('city', 'intercity', 'courier', 'freight');--> statement-breakpoint
CREATE TYPE "public"."vehicle_type" AS ENUM('moto', 'rickshaw', 'mini', 'ac', 'comfort', 'loader', 'truck');--> statement-breakpoint
CREATE TYPE "public"."wallet_tx_type" AS ENUM('bonus', 'commission', 'topup', 'adjustment');--> statement-breakpoint
CREATE TABLE "drivers" (
	"user_id" uuid PRIMARY KEY NOT NULL,
	"status" "driver_status" DEFAULT 'pending' NOT NULL,
	"rejection_reason" text,
	"cnic_number" text NOT NULL,
	"license_number" text NOT NULL,
	"vehicle_type" "vehicle_type" NOT NULL,
	"vehicle_make" text NOT NULL,
	"vehicle_model" text NOT NULL,
	"vehicle_color" text NOT NULL,
	"vehicle_year" integer,
	"plate_number" text NOT NULL,
	"services" "service_type"[] DEFAULT ARRAY['city']::service_type[] NOT NULL,
	"docs" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"rating" real DEFAULT 5 NOT NULL,
	"rating_count" integer DEFAULT 0 NOT NULL,
	"balance" integer DEFAULT 0 NOT NULL,
	"is_online" boolean DEFAULT false NOT NULL,
	"last_location" geometry(point),
	"last_heading" real,
	"last_seen_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"approved_at" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "messages" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"ride_id" uuid NOT NULL,
	"sender_id" uuid NOT NULL,
	"body" text NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "refresh_tokens" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"token_hash" text NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"revoked_at" timestamp with time zone,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "refresh_tokens_token_hash_unique" UNIQUE("token_hash")
);
--> statement-breakpoint
CREATE TABLE "ride_offers" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"ride_id" uuid NOT NULL,
	"driver_id" uuid NOT NULL,
	"price" integer NOT NULL,
	"eta_sec" integer NOT NULL,
	"distance_m" integer NOT NULL,
	"status" "offer_status" DEFAULT 'pending' NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"expires_at" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "rides" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"passenger_id" uuid NOT NULL,
	"driver_id" uuid,
	"service_type" "service_type" DEFAULT 'city' NOT NULL,
	"vehicle_type" "vehicle_type" NOT NULL,
	"status" "ride_status" DEFAULT 'searching' NOT NULL,
	"pickup" geometry(point) NOT NULL,
	"pickup_address" text NOT NULL,
	"dropoff" geometry(point) NOT NULL,
	"dropoff_address" text NOT NULL,
	"distance_m" integer NOT NULL,
	"duration_s" integer NOT NULL,
	"route_polyline" text,
	"recommended_fare" integer NOT NULL,
	"min_fare" integer NOT NULL,
	"offered_fare" integer NOT NULL,
	"final_fare" integer,
	"commission" integer,
	"payment_method" "payment_method" DEFAULT 'cash' NOT NULL,
	"comment" text,
	"details" jsonb DEFAULT '{}'::jsonb NOT NULL,
	"search_radius_m" integer NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"accepted_at" timestamp with time zone,
	"arrived_at" timestamp with time zone,
	"started_at" timestamp with time zone,
	"completed_at" timestamp with time zone,
	"cancelled_at" timestamp with time zone,
	"cancelled_by" "actor",
	"cancel_reason" text,
	"driver_stars" integer,
	"driver_review" text,
	"passenger_stars" integer,
	"passenger_review" text
);
--> statement-breakpoint
CREATE TABLE "saved_places" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"user_id" uuid NOT NULL,
	"label" text NOT NULL,
	"name" text NOT NULL,
	"address" text NOT NULL,
	"location" geometry(point) NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "sos_alerts" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"ride_id" uuid,
	"user_id" uuid NOT NULL,
	"location" geometry(point),
	"resolved" boolean DEFAULT false NOT NULL,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"phone" text NOT NULL,
	"name" text,
	"email" text,
	"photo_url" text,
	"language" text DEFAULT 'en' NOT NULL,
	"rating" real DEFAULT 5 NOT NULL,
	"rating_count" integer DEFAULT 0 NOT NULL,
	"is_blocked" boolean DEFAULT false NOT NULL,
	"fcm_token" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL,
	"updated_at" timestamp with time zone DEFAULT now() NOT NULL,
	CONSTRAINT "users_phone_unique" UNIQUE("phone")
);
--> statement-breakpoint
CREATE TABLE "wallet_transactions" (
	"id" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"driver_id" uuid NOT NULL,
	"amount" integer NOT NULL,
	"type" "wallet_tx_type" NOT NULL,
	"ride_id" uuid,
	"note" text,
	"created_at" timestamp with time zone DEFAULT now() NOT NULL
);
--> statement-breakpoint
ALTER TABLE "drivers" ADD CONSTRAINT "drivers_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "messages" ADD CONSTRAINT "messages_ride_id_rides_id_fk" FOREIGN KEY ("ride_id") REFERENCES "public"."rides"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "messages" ADD CONSTRAINT "messages_sender_id_users_id_fk" FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ride_offers" ADD CONSTRAINT "ride_offers_ride_id_rides_id_fk" FOREIGN KEY ("ride_id") REFERENCES "public"."rides"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "ride_offers" ADD CONSTRAINT "ride_offers_driver_id_users_id_fk" FOREIGN KEY ("driver_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "rides" ADD CONSTRAINT "rides_passenger_id_users_id_fk" FOREIGN KEY ("passenger_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "rides" ADD CONSTRAINT "rides_driver_id_users_id_fk" FOREIGN KEY ("driver_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "saved_places" ADD CONSTRAINT "saved_places_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "sos_alerts" ADD CONSTRAINT "sos_alerts_ride_id_rides_id_fk" FOREIGN KEY ("ride_id") REFERENCES "public"."rides"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "sos_alerts" ADD CONSTRAINT "sos_alerts_user_id_users_id_fk" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wallet_transactions" ADD CONSTRAINT "wallet_transactions_driver_id_drivers_user_id_fk" FOREIGN KEY ("driver_id") REFERENCES "public"."drivers"("user_id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "wallet_transactions" ADD CONSTRAINT "wallet_transactions_ride_id_rides_id_fk" FOREIGN KEY ("ride_id") REFERENCES "public"."rides"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "drivers_plate_idx" ON "drivers" USING btree ("plate_number");--> statement-breakpoint
CREATE UNIQUE INDEX "drivers_cnic_idx" ON "drivers" USING btree ("cnic_number");--> statement-breakpoint
CREATE INDEX "drivers_location_gist" ON "drivers" USING gist (("last_location"::geography));--> statement-breakpoint
CREATE INDEX "messages_ride_idx" ON "messages" USING btree ("ride_id","created_at");--> statement-breakpoint
CREATE INDEX "refresh_tokens_user_idx" ON "refresh_tokens" USING btree ("user_id");--> statement-breakpoint
CREATE UNIQUE INDEX "ride_offers_ride_driver_idx" ON "ride_offers" USING btree ("ride_id","driver_id");--> statement-breakpoint
CREATE INDEX "rides_pickup_gist" ON "rides" USING gist (("pickup"::geography));--> statement-breakpoint
CREATE INDEX "rides_status_idx" ON "rides" USING btree ("status");--> statement-breakpoint
CREATE INDEX "rides_passenger_idx" ON "rides" USING btree ("passenger_id","created_at");--> statement-breakpoint
CREATE INDEX "rides_driver_idx" ON "rides" USING btree ("driver_id","created_at");--> statement-breakpoint
CREATE UNIQUE INDEX "rides_one_active_per_passenger" ON "rides" USING btree ("passenger_id") WHERE status in ('searching','accepted','arrived','in_progress');--> statement-breakpoint
CREATE UNIQUE INDEX "rides_one_active_per_driver" ON "rides" USING btree ("driver_id") WHERE status in ('accepted','arrived','in_progress');--> statement-breakpoint
CREATE INDEX "saved_places_user_idx" ON "saved_places" USING btree ("user_id");--> statement-breakpoint
CREATE INDEX "wallet_tx_driver_idx" ON "wallet_transactions" USING btree ("driver_id","created_at");