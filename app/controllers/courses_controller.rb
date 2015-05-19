class CoursesController < HtmlResponsableController
  include Crudable

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

    associate_to_teachers

    @course.save

    respond_with(@course)
  end

  def update
    associate_to_teachers

    @course.update(course_params)

    respond_with(@course)

    remove_teachers_associations
  end

  def destroy
    @course.destroy.destroyed?

    respond_with(@course)
  end

  private

  def set_resource
    @course = Course.find(params[:id])

    authorize @course
  end

  def course_params
    params.require(:course).permit(:title, :description)
  end

  def associate_to_teachers
    (new_teacher_profile_ids - @course.teacher_profiles.ids).each do |id|
      @course.teacher_specialities.build(teacher_profile_id: id)
    end
  end

  def remove_teachers_associations
    teacher_profile_ids = @course.teacher_profiles.ids - new_teacher_profile_ids

    TeacherSpeciality.where(course_id: @course.id, teacher_profile_id: teacher_profile_ids).destroy_all
  end

  def new_teacher_profile_ids
    (params[:course][:teacher_profile_ids] || []).select(&:present?).map(&:to_i)
  end
end
