class ChangePsyhoTestFormatTypeAndPopulateOptions < ActiveRecord::Migration
  def up
    Question.where(format: 'boolean').each do |q|
      q.format          = 'single_select'
      q.data[:options]  = { uk: [['Так', true], ['Ні', false]], ru: [['Да', true], ['Нет', false]] }

      q.save!
    end
  end

  def down
    Question.where(format: 'single_select').update_all(format: 'boolean')
  end
end
