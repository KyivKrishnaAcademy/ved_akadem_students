class NotesController < HtmlRespondableController
  before_action :set_note, only: %i[edit update destroy]

  after_action :verify_authorized

  def index
    @notes = Note.where(person_id: params[:person_id])

    authorize Note

    respond_with(@notes)
  end

  def new
    @note = Note.new(person: Person.find(params[:person_id]), date: Time.zone.today)

    authorize @note

    respond_with(@note)
  end

  def edit; end

  def create
    @note = Note.new(note_params)

    authorize @note

    @note.save

    respond_with_person_note
  end

  def update
    @note.update(note_params)

    respond_with_person_note
  end

  def destroy
    @note.destroy

    respond_with_person_note
  end

  private

  def respond_with_person_note
    respond_with(
      @note,
      location: -> { person_path(@note.person_id) }
    )
  end

  def set_note
    @note = Note.find_by!(id: params[:id], person_id: params[:person_id])

    authorize @note
  end

  def note_params
    params.require(:note).permit(:date, :message, :person_id)
  end
end
