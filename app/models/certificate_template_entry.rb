class CertificateTemplateEntry < ApplicationRecord
  belongs_to :certificate_template
  belongs_to :certificate_template_font

  enum align: %i[center left right justify].freeze

  HEX_COLOR_REGEX = /\A#(?:[0-9a-fA-F]{3}){1,2}\z/.freeze

  validates :align,
            :character_spacing,
            :font_size,
            :template,
            :x,
            :y,
            presence: true

  validates :color,
            presence: true,
            format: { with: HEX_COLOR_REGEX }

  has_paper_trail
end
