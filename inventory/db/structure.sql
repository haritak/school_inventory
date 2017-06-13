CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE IF NOT EXISTS "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "username" varchar, "password_digest" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE UNIQUE INDEX "index_users_on_username" ON "users" ("username");
CREATE TABLE IF NOT EXISTS "items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "serial" varchar, "description" varchar, "photo_file" varchar, "photo_data" blob, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE UNIQUE INDEX "index_items_on_serial" ON "items" ("serial");
INSERT INTO "schema_migrations" (version) VALUES
('20170613053858'),
('20170613054423');


