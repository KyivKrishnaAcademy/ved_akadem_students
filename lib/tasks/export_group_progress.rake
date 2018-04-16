namespace :academic do
  desc 'Export academic group progress'
  task export_group_progress: :environment do
    BASE_DIR = Rails.root.join 'tmp'

    group = AcademicGroup.find(12)

    examination_titles =
      group
        .examinations
        .joins(:course)
        .map { |e| [e.id, "#{e.course.title} #{e.title}"] }
        .sort_by(&:last)
        .to_h

    results = ExaminationResult
      .where(examination_id: examination_titles.keys)
      .each_with_object({}) do |r, h|
        h[r.student_profile_id] ||= {}
        h[r.student_profile_id][r.examination_id] = r.score
      end

    people_titles = group.active_students.map { |p| [p.student_profile.id, p.complex_name] }

    xlsx = Axlsx::Package.new

    xlsx.workbook.add_worksheet(name: group.title) do |sheet|
      sheet.add_row(['ПІБ'] + examination_titles.values)

      group.active_students.each do |p|
        sp_id = p.student_profile.id

        scores = examination_titles.keys.map { |e_id| (results[sp_id] || {})[e_id] || '' }

        sheet.add_row([p.complex_name] + scores)
      end
    end

    xlsx.serialize(BASE_DIR.join("#{group.title}_progress.xlsx"))

    puts "\nDone!"
  end
end
