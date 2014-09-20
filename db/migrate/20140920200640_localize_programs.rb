class LocalizePrograms < ActiveRecord::Migration
  def change
    add_column    :programs, :title_ua      , :string
    add_column    :programs, :title_ru      , :string
    add_column    :programs, :description_ua, :text
    add_column    :programs, :description_ru, :text
    add_column    :programs, :courses_ua    , :text
    add_column    :programs, :courses_ru    , :text
    remove_column :programs, :title         , :string
    remove_column :programs, :description   , :text
  end
end
