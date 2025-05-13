FactoryBot.define do
  factory :certificate_template_entry do
    template {"MyString"}
    certificate_template {nil}
    certificate_template_font {nil}
    character_spacing {1.5}
    x {1}
    y {1}
    font_size {1}
    align {"MyString"}
  end
end
