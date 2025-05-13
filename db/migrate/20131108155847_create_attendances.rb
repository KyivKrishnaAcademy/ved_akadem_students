class CreateAttendances < ActiveRecord::Migration[5.0]
  def change
    create_table :attendances do |t|

      t.timestamps
    end
  end
end
