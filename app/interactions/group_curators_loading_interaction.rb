class GroupCuratorsLoadingInteraction < BaseInteraction
  include Peoplable

  def init
    #TODO replace this when ElasticSearch appears
    @people = Person.joins(:teacher_profile).where('complex_name ILIKE ?', "%#{params[:q]}%") #injection is possible!
  end
end
