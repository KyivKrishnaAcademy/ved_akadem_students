class AcademicYearsService
  def self.calculate(from_year, to_year)
    years = (from_year.to_i..(to_year.to_i)).to_a

    years[0..-2]
      .zip(years[1..-1])
      .map do |start_year, end_year|
      {
        start: Time.zone.local(start_year, 9),
        finish: Time.zone.local(end_year, 8, 31).end_of_day
      }
    end
  end
end
