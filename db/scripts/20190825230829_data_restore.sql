do $$
begin
  IF EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'rollback' AND tablename = 'workshops_20190825230829') THEN
    UPDATE workshops
    SET is_public = rb.is_public
    FROM rollback.workshops_20190825230829 rb
    WHERE workshops.id = rb.id;
  END IF;
end
$$
