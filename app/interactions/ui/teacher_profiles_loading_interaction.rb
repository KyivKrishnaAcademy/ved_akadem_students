module Ui
  class TeacherProfilesLoadingInteraction < BaseInteraction
    def init
      @teacher_profiles = TeacherProfile
                            .includes(:person)
                            .joins(:person)
                            .ilike('people.complex_name', params[:q])
    end

    def serialize_profile(profile)
      {
        id: profile.id,
        text: profile.person.complex_name,
        imageUrl: photo_url(profile.person)
      }
    end

    def as_json(_opts = {})
      {
        teacher_profiles: @teacher_profiles.map { |p| serialize_profile p }
      }
    end
  end
end
