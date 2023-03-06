module CoursesHelper
  def link_to_destroy_course(course)
    link_to_disabled_destroy(
      policy(course).destroy?,
      course.class_schedules_count.positive? || course.examination_results_count.positive?,
      course_path(course),
      t('courses.destroy.prerequisites_are_not_met')
    )
  end
end
