class RenameDiplomaNameToSpiritualName < ActiveRecord::Migration[5.0]
  def change
    rename_column :people, :spiritual_name, :spiritual_name
    add_column :people, :diksha_guru, :string
  end
end
