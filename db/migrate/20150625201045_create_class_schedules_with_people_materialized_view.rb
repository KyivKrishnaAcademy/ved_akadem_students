class CreateClassSchedulesWithPeopleMaterializedView < ActiveRecord::Migration
  def up
    connection.execute(IO.read(Rails.root.join('db/materialized_views/class_schedules_with_people_v1.sql')))
  end

  def down
    connection.execute('DROP MATERIALIZED VIEW IF EXISTS class_schedules_with_people')
  end
end
