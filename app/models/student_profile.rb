class StudentProfile < ActiveRecord::Base
  belongs_to  :person
  has_many    :group_participations, dependent: :destroy
  has_many    :akadem_groups       , through:   :group_participations
  has_many    :attendances         , dependent: :destroy
  has_many    :class_schedules     , through:   :attendances

  def move_to_group(akadem_group)
    remove_from_groups

    akadem_groups << akadem_group
  end

  def remove_from_groups
    prev = group_participations.where(leave_date: nil).first

    prev.leave! if prev.present?
  end
end
