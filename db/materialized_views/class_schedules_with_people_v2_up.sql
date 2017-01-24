-- Do not change after merge to master, because it will produce irreversible migration
-- create new version instead

CREATE MATERIALIZED VIEW class_schedules_with_people AS
SELECT
  cs.id,
  cs.course_id,
  cs.teacher_profile_id,
  cs.classroom_id,
  cs.start_time,
  cs.finish_time,
  cs.subject,
  (
    SELECT tp.person_id
    FROM teacher_profiles tp
    WHERE tp.id = cs.teacher_profile_id
  ) AS teacher_id,
  ARRAY(
    SELECT DISTINCT p.id
    FROM people p
    INNER JOIN student_profiles sp ON sp.person_id = p.id
    INNER JOIN group_participations gp ON gp.student_profile_id = sp.id
    INNER JOIN academic_groups ag ON ag.id = gp.academic_group_id
    INNER JOIN academic_group_schedules ags ON ags.academic_group_id = ag.id
    WHERE
      ags.class_schedule_id = cs.id AND
      gp.leave_date IS NULL AND
      ag.graduated_at IS NULL
  ) AS people_ids
FROM class_schedules cs
ORDER BY
  cs.start_time ASC,
  cs.finish_time ASC
;

CREATE UNIQUE INDEX class_schedules_with_people_id_idx ON class_schedules_with_people (id);

CREATE INDEX class_schedules_with_people_people_ids_idx
ON class_schedules_with_people
USING gin (people_ids)
WITH (fastupdate = off);

CREATE INDEX class_schedules_with_people_teacher_id_idx
ON class_schedules_with_people
USING hash (teacher_id);

REFRESH MATERIALIZED VIEW class_schedules_with_people;
