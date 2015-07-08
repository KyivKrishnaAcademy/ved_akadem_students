-- Do not change after merge to master, because it will produce irreversible migration
-- create new version instead

DROP INDEX IF EXISTS class_schedules_with_people_id_idx;
DROP INDEX IF EXISTS class_schedules_with_people_people_ids_idx;
DROP INDEX IF EXISTS class_schedules_with_people_teacher_id_idx;

DROP MATERIALIZED VIEW IF EXISTS class_schedules_with_people;
