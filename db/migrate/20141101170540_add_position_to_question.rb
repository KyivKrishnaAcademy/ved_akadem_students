class AddPositionToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :position, :integer
  end
end
