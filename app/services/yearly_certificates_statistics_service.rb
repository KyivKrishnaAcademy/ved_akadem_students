class YearlyCertificatesStatisticsService
  attr_reader :certificates_yearly_data, :year_headers

  def initialize(from_year, to_year)
    @from_year = from_year
    @to_year = to_year
  end

  def calculate
    calculate_academic_years
    calculate_certificate_counts_by_years
    gather_certificates_yearly_data
    construct_headers

    nil
  end

  private

  def calculate_academic_years
    @academic_years = AcademicYearsService.calculate(@from_year, @to_year)
  end

  def calculate_certificate_counts_by_years
    @certificate_counts_by_years = @academic_years.each_with_object({}) do |year, acc|
      acc[year] = Certificate
                    .where('issued_date > :start AND issued_date <= :finish', { start: year[:start],
                                                                                finish: year[:finish] })
                    .group(:certificate_template_id)
                    .count
    end
  end

  def construct_headers
    @year_headers = @academic_years.map { |year| "#{year[:start].year}/#{year[:finish].year}" }
  end

  def gather_certificates_yearly_data
    @certificates_yearly_data = Institution.all.each_with_object({}) do |institution, acc|
      acc[institution.name] = gather_institution_data(institution.id)
    end
  end

  def gather_institution_data(institution_id)
    CertificateTemplate.program_types.keys.each_with_object({}) do |program_type, acc|
      acc[program_type] = gather_years_data(institution_id, program_type)
    end
  end

  def gather_years_data(institution_id, program_type)
    certificate_template_ids = CertificateTemplate.where(institution_id: institution_id, program_type: program_type).ids

    @academic_years.each_with_object({}) do |year, acc|
      acc[year[:start]] = count_certificates(certificate_template_ids, year)
    end
      .sort
      .map(&:last)
  end

  def count_certificates(certificate_template_ids, year)
    @certificate_counts_by_years[year].reduce(0) do |acc, (template_id, count)|
      if certificate_template_ids.include?(template_id)
        acc + count
      else
        acc
      end
    end
  end
end
