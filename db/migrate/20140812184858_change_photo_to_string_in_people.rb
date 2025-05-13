class ChangePhotoToStringInPeople < ActiveRecord::Migration[5.0]
  def up
    change_table :people do |t|
      t.change :photo, :string
    end
  end

  def down
    change_table :people do |t|
      t.change :photo, :text
    end
  end
end
