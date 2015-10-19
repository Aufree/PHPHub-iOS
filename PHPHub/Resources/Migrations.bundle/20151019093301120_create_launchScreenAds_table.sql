-- ----------------------------
--  Table structure for launchScreenAds
-- ----------------------------
DROP TABLE IF EXISTS "launchScreenAds";
CREATE TABLE "launchScreenAds" (
"id" integer not null primary key,
"image_small" varchar not null,
"image_large" varchar not null,
"type" varchar null,
"payload" varchar not null,
"display_time" integer not null default '0',
"start_at" datetime not null,
"expires_at" datetime not  null
);
-- ----------------------------
--  Indexes structure for table launchScreenAds
-- ----------------------------
CREATE INDEX launchScreenAds_expiresAt_index on "launchScreenAds" ("expires_at");