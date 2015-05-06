class CoursesController < HtmlResponsableController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized

  def index
    @courses = Course.order(:title)

    authorize Course

    respond_with(@courses)
  end

  def show
    respond_with(@course)
  end

  def new
    @course = Course.new

    authorize @course

    respond_with(@course)
  end

  def edit
    respond_with(@course)
  end

  def create
    @course = Course.new(course_params)

    authorize @course

    @course.save

    respond_with(@course)
  end

  def update
    @course.update(course_params)
    respond_with(@course)
  end

  def destroy
    @course.destroy.destroyed?
    respond_with(@course)
  end

  private

  def set_course
    @course = Course.find(params[:id])

    authorize @course
  end

  def course_params
    params.require(:course).permit(:title, :description)
  end
end
