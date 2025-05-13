class LocalizePrograms < ActiveRecord::Migration[5.0]
  def change
    add_column    :programs, :title_uk      , :string
    add_column    :programs, :title_ru      , :string
    add_column    :programs, :description_uk, :text
    add_column    :programs, :description_ru, :text
    add_column    :programs, :courses_uk    , :text
    add_column    :programs, :courses_ru    , :text
    remove_column :programs, :title         , :string
    remove_column :programs, :description   , :text
  end
end
