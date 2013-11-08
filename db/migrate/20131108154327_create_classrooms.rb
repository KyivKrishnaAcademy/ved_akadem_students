class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|

      t.timestamps
    end
  end
end
