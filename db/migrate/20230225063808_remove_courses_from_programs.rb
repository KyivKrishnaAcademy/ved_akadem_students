class RemoveCoursesFromPrograms < ActiveRecord::Migration[5.0]
  def up
    Program.all.each do |program|
      move_courses(program, 'uk', 'Предмети що розглядаються на курсі:')
      move_courses(program, 'ru', 'Предметы рассматриваемые на курсе:')

      program.save if program.changed?
    end

    remove_column :programs, :courses_uk
    remove_column :programs, :courses_ru
  end

  def down
    add_column :programs, :courses_uk, :text
    add_column :programs, :courses_ru, :text
  end

  private

  def move_courses(program, locale, transition_phrase)
    courses_key = "courses_#{locale}"

    return if program[courses_key].blank?

    courses = YAML.load(program[courses_key])
    description_key = "description_#{locale}"

    courses.unshift(transition_phrase)
    program[description_key].strip!
    program[description_key].concat("\n", courses.join("\n  - "))
  end
end
