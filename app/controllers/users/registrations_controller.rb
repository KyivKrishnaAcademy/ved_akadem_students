class Users::RegistrationsController < Devise::RegistrationsController
  include CropDirectable

  before_action :configure_permitted_parameters
  before_action :remove_empty_password, only: :update

  def new
    build_resource({})

    resource.telephones.build

    @validatable = devise_mapping.validatable?

    if @validatable
      @minimum_password_length = resource_class.password_length.min
    end

    respond_with self.resource
  end

  def destroy
    if resource.student_profile.present? || resource.teacher_profile.present?
      new_email = "#{SecureRandom.hex(3)}.deleted.#{resource.email}"

      resource.update_attributes(email: new_email, skip_password_validation: true, deleted: true)
    else
      resource.destroy
    end

    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)

    set_flash_message :notice, :destroyed if is_flashing_format?

    yield resource if block_given?

    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  private

  def after_sign_up_path_for(resource)
    direct_to_crop(super(resource), resource)
  end

  def after_inactive_sign_up_path_for(resource)
    direct_to_crop(super(resource), resource)
  end

  def after_update_path_for(resource)
    direct_to_crop(super(resource), resource)
  end

  def configure_permitted_parameters
    permitted_params = [:name, :surname, :spiritual_name, :middle_name, :gender, :photo,
                        :birthday, :education, :work, :emergency_contact, :passport, :marital_status,
                        :friends_to_be_with, telephones_attributes: [:id, :phone, :_destroy]]

    devise_parameter_sanitizer.for(:sign_up) << permitted_params << [:photo_cache, :passport_cache, :privacy_agreement]
    devise_parameter_sanitizer.for(:account_update) << permitted_params << [:photo_cache, :passport_cache]
  end

  def remove_empty_password
    if params[:person][:password].blank? && params[:person][:password_confirmation].blank?
      params[:person].delete(:password)
      params[:person].delete(:password_confirmation)
      params[:person].merge!(skip_password_validation: true)

      devise_parameter_sanitizer.for(:account_update) << [:skip_password_validation]
    end
  end
end
