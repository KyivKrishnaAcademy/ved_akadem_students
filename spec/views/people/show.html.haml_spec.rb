# require 'rails_helper'

describe 'people/show.html.haml' do
  Given(:study_application_policy) { StudyApplicationPolicy.new(user, new_study_application) }
  Given(:new_study_application) { StudyApplication.new(person_id: person.id) }
  Given(:activities) { ['person:show'] }
  Given(:person) { create :person }
  Given(:group) { create :academic_group }
  Given(:page) { Capybara::Node::Simple.new(response.body) }
  Given(:user) { create :person, roles: [create(:role, activities: activities)] }

  Given { allow(view).to receive(:policy).with(new_study_application).and_return(study_application_policy) }
  Given { allow(view).to receive(:policy).with(person).and_return(PersonPolicy.new(user, person)) }
  Given { allow(view).to receive(:policy).with(Note).and_return(PersonPolicy.new(user, Note)) }
  Given { assign(:application_person, person) }
  Given { assign(:programs, []) }
  Given { assign(:new_study_application, new_study_application) }
  Given { assign(:person, person) }
  Given { assign(:academic_groups, []) }
  Given { assign(:prev_group_participations, []) }
  Given { assign(:certificates, []) }

  Given { login_as(user) }

  When { render file: 'people/show.html.haml', layout: 'layouts/person_tabs' }

  describe 'general' do
    Then { expect(rendered).to have_selector('h1', text: complex_name(person)) }
    And  { expect(rendered).to have_text("Telephone 1: #{person.telephones.first.phone}") }
    And  { expect(rendered).to have_text("Email: #{person.email}") }
    And  { expect(rendered).to have_text(/Gender: (Male|Female)/) }
    And  { expect(rendered).to have_text("Birthday: #{person.birthday}") }
  end

  describe 'study application' do
    Given(:have_apply_button) { have_selector('button.btn-submit', text: I18n.t('links.apply_to_program')) }
    Given(:have_withdraw_button) { have_selector('button.btn-submit', text: I18n.t('links.withdraw')) }

    shared_examples :show_submit do
      Then { expect(rendered).to have_apply_button }
      And  { expect(rendered).not_to have_withdraw_button }
    end

    shared_examples :show_withdraw do
      Given(:study_application) { StudyApplication.create(program: program, person: person) }

      Given do
        allow(view)
          .to receive(:policy).with(study_application).and_return(StudyApplicationPolicy.new(user, study_application))
      end

      Given do
        allow(view).to receive(:policy).with(program.manager).and_return(PersonPolicy.new(user, program.manager))
      end

      Then  { expect(rendered).to have_withdraw_button }
      And   { expect(rendered).not_to have_apply_button }
    end

    Given(:program) { create(:program) }

    Given { assign(:programs, [program]) }

    describe 'owned' do
      Given(:user) { person }

      describe 'submit' do
        it_behaves_like :show_submit
      end

      describe 'withdraw' do
        it_behaves_like :show_withdraw
      end
    end

    describe 'other person' do
      context 'no role' do
        Then do
          expect(rendered)
            .not_to have_selector("input[type='submit'][name='commit'][value='#{I18n.t('links.apply_to_program')}']")
        end

        And { expect(rendered).not_to have_link(I18n.t('links.withdraw')) }
      end

      describe 'submit with role' do
        Given(:activities) { ['study_application:create'] }

        it_behaves_like :show_submit
      end

      describe 'withdraw with role' do
        Given(:activities) { ['study_application:destroy'] }

        it_behaves_like :show_withdraw
      end
    end
  end

  describe 'psycho test' do
    Given(:psycho_test) { create :questionnaire, :psycho_test }

    Given { QuestionnaireCompleteness.create(person: person, questionnaire: psycho_test) }
    Given { psycho_test.questions.each { |question| Answer.create(person: person, question: question, data: '1') } }
    Given { AnswersProcessorService.new(psycho_test, person).process! }

    context 'no role' do
      Then { expect(rendered).not_to have_selector('h3', text: 'Psycho Test Results') }
    end

    context 'with role' do
      Given(:activities) { ['person:view_psycho_test_result'] }

      Then { expect(rendered).to have_selector('h3', text: 'Psycho Test Results') }
    end
  end

  describe 'edit link' do
    context 'no role' do
      Then { expect(rendered).not_to have_link(I18n.t('links.edit'), href: edit_person_path(person)) }
    end

    context 'with role' do
      Given(:activities) { ['person:edit'] }

      Then { expect(rendered).to have_link(I18n.t('links.edit'), href: edit_person_path(person)) }
    end
  end

  describe 'destroy link' do
    context 'no role' do
      Then { expect(rendered).not_to have_link(I18n.t('links.delete'), href: person_path(person)) }
    end

    context 'with role' do
      Given(:activities) { ['person:destroy'] }

      Then { expect(rendered).to have_link(I18n.t('links.delete'), href: person_path(person)) }
    end
  end

  describe 'change group dropdown' do
    Given { assign(:academic_groups, [group]) }

    context 'no role' do
      Then { expect(rendered).not_to have_selector('button.dropdown-toggle', text: 'Add to group') }
    end

    context 'with roles' do
      Given(:menu) { page.find('#change-academic-group ul.dropdown-menu') }

      describe 'move to group link' do
        Given(:activities) { ['person:move_to_group'] }

        Then do
          expect(rendered).to have_selector('#change-academic-group button.dropdown-toggle', text: 'Add to group')
        end

        And { expect(menu).to have_link(group.title, href: '#') }
      end
    end
  end

  describe 'crop image link' do
    Given(:person) { create :person, :with_photo }

    context 'no role' do
      context 'owned' do
        Given(:user) { person }

        Then { expect(rendered).to have_link(I18n.t('links.crop_photo'), href: crop_image_path(person.id)) }
      end

      context 'other person' do
        Then { expect(rendered).not_to have_link(I18n.t('links.crop_photo'), href: crop_image_path(person.id)) }
      end
    end

    context 'with role' do
      Given(:activities) { ['person:crop_image'] }

      Then { expect(rendered).to have_link(I18n.t('links.crop_photo'), href: crop_image_path(person.id)) }
    end
  end

  describe 'link to group' do
    context 'person has group' do
      Given { person.create_student_profile.move_to_group(group) }

      Given(:group_participation) { group.group_participations.first }
      Given(:group_participation_policy) { GroupParticipationPolicy.new(user, group) }

      Given { allow(view).to receive(:policy).with(group_participation).and_return(group_participation_policy) }

      Then  { expect(rendered).to have_link(group.title, href: academic_group_path(group)) }
    end

    context 'person has no group' do
      Then { expect(rendered).not_to have_link(group.title, href: academic_group_path(group)) }
    end
  end
end
