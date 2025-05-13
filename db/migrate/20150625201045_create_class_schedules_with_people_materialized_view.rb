class CreateClassSchedulesWithPeopleMaterializedView < ActiveRecord::Migration[5.0]
  def up
    down

    connection.execute(IO.read(Rails.root.join('db/materialized_views/class_schedules_with_people_v1_up.sql')))
  end

  def down
    connection.execute(IO.read(Rails.root.join('db/materialized_views/class_schedules_with_people_v1_down.sql')))
  end
end
