class CertificateTemplate < ActiveRecord::Base
  FIELDS        = %i(holder_name cert_id date)
  DIMENSIONS    = %i(x y w h)
  ARRAY_FIELDS  = %i(teachers)

  serialize :fields, HashSerializer

  enum status: %i(draft ready)

  mount_uploader :background, CertificateTemplateUploader

  validates :background, :title, presence: true

  def init_fields
    return fields if fields.present?

    dims         = { x: 0, y: 0 }
    fields_count = FIELDS.count + ARRAY_FIELDS.count * 2
    gap          = 30
    x_step       = background_width / fields_count + gap / fields_count
    y_step       = background_height / fields_count + gap / fields_count
    dims[:w]     = background_width / fields_count - gap
    dims[:h]     = background_height / fields_count - gap

    FIELDS.each do |field|
      set_hash_field(field, dims)

      dims[:x] += x_step
      dims[:y] += y_step
    end

    2.times do # TODO remove when fields add/remove implemented on UI
      ARRAY_FIELDS.each do |field|
        set_array_field(field, dims)

        dims[:x] += x_step
        dims[:y] += y_step
      end
    end

    fields
  end

  private

  def set_hash_field(field, dimensions)
    self.fields[field] = {}

    DIMENSIONS.each do |dimension|
      self.fields[field][dimension] = dimensions[dimension]
    end
  end

  def set_array_field(field, dimensions)
    self.fields[field] ||= []
    self.fields[field] << {}

    DIMENSIONS.each do |dimension|
      self.fields[field].last[dimension] = dimensions[dimension]
    end
  end
end
