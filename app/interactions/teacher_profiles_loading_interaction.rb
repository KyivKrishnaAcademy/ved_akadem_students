class TeacherProfilesLoadingInteraction < BaseInteraction
  def init
    #TODO replace this when ElasticSearch appears
    @teacher_profiles = TeacherProfile.includes(:person)
                                      .joins(:person)
                                      .where('people.complex_name ILIKE ?', "%#{params[:q]}%") #injection is possible!
  end

  def serialize_profile(profile)
    {
      id: profile.id,
      text: profile.person.complex_name,
      imageUrl: photo_url(profile.person)
    }
  end

  def as_json(opts = {})
    {
      teacher_profiles: @teacher_profiles.map { |p| serialize_profile p }
    }
  end
end
