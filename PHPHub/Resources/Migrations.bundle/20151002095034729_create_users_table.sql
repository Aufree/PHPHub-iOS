-- ----------------------------
--  Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS "users";
CREATE TABLE "users" (
"id" integer not null primary key,
"name" varchar not null,
"avatar" varchar null,
"github_url" varchar null,
"topic_count" integer not null default '0',
"reply_count" integer not null default '0',
"twitter_account" varchar null,
"personal_website" varchar null,
"company" varchar null,
"city" varchar null,
"email" varchar null,
"introduction" varchar null,
"github_name" varchar null,
"real_name" varchar null,
"replies_web_view" varchar null,
"created_at" datetime not null,
"updated_at" datetime null
);