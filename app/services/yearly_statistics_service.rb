class YearlyStatisticsService
  attr_reader :groups_yearly_data, :total_uniq_counts, :year_headers

  def initialize(from_year, to_year)
    @from_year = from_year
    @to_year = to_year
  end

  def calculate
    calculate_academic_years
    gather_groups_yearly_data
    gather_total_uniq_counts
    construct_headers

    nil
  end

  private

  def calculate_academic_years
    years = (@from_year.to_i..(@to_year.to_i)).to_a

    @academic_years =
      years[0..-2]
        .zip(years[1..-1])
        .map do |start_year, end_year|
          {
            start: Time.zone.local(start_year, 9),
            finish: Time.zone.local(end_year, 8, 31).end_of_day
          }
        end
  end

  def gather_groups_yearly_data
    @groups_yearly_data = groups_in_the_scope.map do |group|
      yearly_counts = @academic_years.map do |year|
        active_students_count(group: group, start: year[:start], finish: year[:finish])
      end

      { group: group, yearly_counts: yearly_counts }
    end
  end

  def groups_in_the_scope
    start = @academic_years.first[:start]
    finish = @academic_years.last[:finish]

    AcademicGroup
      .where('establ_date <= ?', finish)
      .where('graduated_at IS NULL OR (graduated_at BETWEEN ? and ?)', start, finish)
      .order("date_part('year', establ_date), title")
  end

  def active_students_count(start:, finish:, group: nil)
    return if group && group.establ_date > finish

    relation = GroupParticipation
    relation = relation.where(academic_group: group) if group

    relation
      .where('join_date <= ?', finish)
      .where('leave_date IS NULL OR (leave_date BETWEEN ? and ?)', start, finish)
      .count('DISTINCT student_profile_id')
  end

  def gather_total_uniq_counts
    @total_uniq_counts = @academic_years.map do |year|
      active_students_count(start: year[:start], finish: year[:finish])
    end
  end

  def construct_headers
    @year_headers = @academic_years.map { |year| "#{year[:start].year}/#{year[:finish].year}" }
  end
end
