shared_context :certificate_templates_context do
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [role] }
  Given(:role) { create :role, activities: ["certificate_template:#{base_activity}", "certificate_template:#{activity}"] }

  Given(:template) { create :certificate_template }

  Given(:new_link_selector) { "a[href='#{new_certificate_template_path}'] .glyphicon-file" }
  Given(:edit_link_selector) { "a[href='#{edit_certificate_template_path(template)}'] .glyphicon-pencil" }
  Given(:index_link_selector) { "a[href='#{certificate_templates_path}'] .glyphicon-list" }
  Given(:markup_link_selector) { "a[href='#{markup_certificate_template_path(template)}'] .glyphicon-picture" }
  Given(:destroy_link_selector) { "a[href='#{certificate_template_path(template)}'] .glyphicon-trash" }

  Given(:new_link) { is_expected.to have_selector(new_link_selector) }
  Given(:edit_link) { is_expected.to have_selector(edit_link_selector) }
  Given(:index_link) { is_expected.to have_selector(index_link_selector) }
  Given(:markup_link) { is_expected.to have_selector(markup_link_selector) }
  Given(:destroy_link) { is_expected.to have_selector(destroy_link_selector) }

  Given(:no_new_link) { is_expected.not_to have_selector(new_link_selector) }
  Given(:no_edit_link) { is_expected.not_to have_selector(edit_link_selector) }
  Given(:no_index_link) { is_expected.not_to have_selector(index_link_selector) }
  Given(:no_markup_link) { is_expected.not_to have_selector(markup_link_selector) }
  Given(:no_destroy_link) { is_expected.not_to have_selector(destroy_link_selector) }

  Given do
    allow(view).to receive(:policy).with(CertificateTemplate)
                                   .and_return(CertificateTemplatePolicy.new(user, CertificateTemplate))
    allow(view).to receive(:policy).with(template)
                                   .and_return(CertificateTemplatePolicy.new(user, template))
  end

  When  { sign_in(user) }
  When  { render }
end
