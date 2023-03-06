module CoursesHelper
  def link_to_destroy_course(course)
    link_to_disabled_destroy(
      policy(course).destroy?,
      course.class_schedules_count.positive? || course.examination_results_count.positive?,
      course_path(course),
      t('courses.destroy.prerequisites_are_not_met')
    )
  end

  def link_to_destroy_examination(examination)
    link_to_disabled_destroy(
      policy(examination).destroy?,
      examination.examination_results_count.positive?,
      course_examination_path(examination.course_id, examination),
      t(
        'examinations.destroy.remove_examination_results_first',
        examination_results_count: examination.examination_results_count
      )
    )
  end
end
