class CertificateTemplateEntry < ApplicationRecord
  belongs_to :certificate_template
  belongs_to :certificate_template_font

  enum align: %i[center left right justify].freeze

  validates :align,
            :certificate_template_font,
            :character_spacing,
            :font_size,
            :template,
            :x,
            :y,
            presence: true
end
