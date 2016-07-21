CREATE TABLE thermostat_events (
  "id" serial,
  "mode" text,
  "duration_in_minutes" integer,
  "started_at" timestamp,
  "start_temperature" integer,
  "start_target_temperature" integer,
  "start_thermostat_info" json,
  "start_forecast" json,
  "ended_at" timestamp,
  "end_temperature" integer,
  "end_target_temperature" integer,
  "end_thermostat_info" json,
  "end_forecast" json,
  "created_at" timestamp,
  "updated_at" timestamp,
  PRIMARY KEY ("id")
);
