class CertificateTemplate < ApplicationRecord
  GAP           = 30
  FIELDS        = %i(holder_name cert_id date).freeze
  DIMENSIONS    = %i(x y w h).freeze
  ARRAY_FIELDS  = %i(teachers).freeze
  FIELDS_COUNT  = FIELDS.count + ARRAY_FIELDS.count * 2

  serialize :fields, HashSerializer

  enum status: %i(draft ready)

  mount_uploader :background, CertificateTemplateUploader

  validates :background, :title, presence: true

  def init_fields
    return fields if fields.present?

    set_hash_fields
    set_array_fields

    fields
  end

  private

  def dims
    @dims ||= {
      x: 0,
      y: 0,
      w: background_width / FIELDS_COUNT - GAP,
      h: background_height / FIELDS_COUNT - GAP
    }
  end

  def x_step
    @x_step ||= background_width / FIELDS_COUNT + GAP / FIELDS_COUNT
  end

  def y_step
    @y_step ||= background_height / FIELDS_COUNT + GAP / FIELDS_COUNT
  end

  def set_hash_fields
    FIELDS.each do |field|
      set_hash_field(field, dims)

      dims[:x] += x_step
      dims[:y] += y_step
    end
  end

  def set_hash_field(field, dimensions)
    fields[field] = {}

    DIMENSIONS.each do |dimension|
      fields[field][dimension] = dimensions[dimension]
    end
  end

  def set_array_fields
    2.times do # TODO: remove when fields add/remove implemented on UI
      ARRAY_FIELDS.each do |field|
        set_array_field(field, dims)

        dims[:x] += x_step
        dims[:y] += y_step
      end
    end
  end

  def set_array_field(field, dimensions)
    fields[field] ||= []
    fields[field] << {}

    DIMENSIONS.each do |dimension|
      fields[field].last[dimension] = dimensions[dimension]
    end
  end
end
