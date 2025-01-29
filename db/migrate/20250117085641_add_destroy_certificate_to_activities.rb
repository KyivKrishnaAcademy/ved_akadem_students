class AddDestroyCertificateToActivities < ActiveRecord::Migration[5.0]
  def up
    execute <<-SQL
      UPDATE roles
      SET activities = array_append(activities, 'certificate:destroy'::varchar)
      WHERE NOT (activities @> ARRAY['certificate:destroy']::varchar[]);
    SQL
  end

  def down
    execute <<-SQL
      UPDATE roles
      SET activities = array_remove(activities, 'certificate:destroy'::varchar)
      WHERE activities @> ARRAY['certificate:destroy']::varchar[];
    SQL
  end
end
