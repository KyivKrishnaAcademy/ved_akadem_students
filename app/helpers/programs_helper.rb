module ProgramsHelper
  def link_to_destroy_program(program)
    link_to_disabled_destroy(
      policy(program).destroy?,
      program.study_applications.any?,
      program_path(program),
      t(
        'programs.destroy.process_study_applications_first',
        study_applications_count: program.study_applications_count
      )
    )
  end
end
