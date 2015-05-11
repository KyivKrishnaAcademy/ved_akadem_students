class TeacherProfilesLoadingInteraction < BaseInteraction
  def init
    #TODO replace this when ElasticSearch appears
    @teacher_profiles = TeacherProfile.includes(:person)
                                      .joins(:person)
                                      .where('people.complex_name ILIKE ?', "%#{params[:q]}%") #injection possible
  end

  def serialize_profiles(profile)
    {
      id: profile.id,
      name: profile.person.complex_name,
      imageUrl: photo_url(profile.person)
    }
  end

  def as_json(opts = {})
    {
      teacher_profiles: @teacher_profiles.map { |p| serialize_profiles p }
    }
  end

  private

  def photo_url(person)
    person.photo.present? ? "/people/show_photo/thumb/#{person.id}" : person.photo.thumb.url
  end
end
