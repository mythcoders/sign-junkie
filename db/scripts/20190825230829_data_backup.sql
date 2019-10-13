CREATE SCHEMA IF NOT EXISTS rollback;

DROP TABLE IF EXISTS rollback.workshops_20190825230829;
CREATE TABLE IF NOT EXISTS rollback.workshops_20190825230829(
  id INTEGER,
  is_public BOOLEAN
);

INSERT INTO rollback.workshops_20190825230829
SELECT id, is_public
FROM public.workshops;