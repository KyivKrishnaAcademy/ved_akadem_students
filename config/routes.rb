Rails.application.routes.draw do
  devise_for :people, path: '', controllers: { registrations: 'users/registrations' }, path_names: { sign_up: 'register' }

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      mount_devise_token_auth_for 'Person', at: 'auth', skip: [:passwords, :registrations]

      resources :people, only: :index
    end
  end

  resources :people, :courses
  resources :class_schedules   , only: [:new, :create, :edit, :update, :index, :destroy]
  resources :study_applications, only: [:create, :destroy]
  resources :answers           , only: [:update, :edit]
  resources :assigned_cert_templates, only: :create
  resources :certificate_templates, except: :show do
    member do
      get :markup
      get :background

      patch :finish
    end
  end

  resources :academic_groups do
    member do
      post :graduate
    end
  end

  scope module: :users do
    get  '/remind_email' => 'emails#new'
    post '/show_emails'  => 'emails#create'
  end

  root 'static_pages#home'

  get 'static_pages/home'
  get 'changelog', controller: :static_pages, action: :changelog
  get 'privacy_agreement', controller: :static_pages, action: :privacy_agreement

  get 'locales/toggle'

  get   'image/crop/:id'  , controller: :crops, action: :crop_image  , as: :crop_image
  patch 'image/update/:id', controller: :crops, action: :update_image, as: :update_image

  get    'people/show_photo/:version/:id'    , controller: :people, action: :show_photo
  get    'people/show_passport/:id'          , controller: :people, action: :show_passport

  namespace :ui do
    resources :academic_groups,  only: :index
    resources :certificates,     only: :create
    resources :classrooms,       only: :index
    resources :courses,          only: :index
    resources :teacher_profiles, only: :index

    get 'group_admins'      , controller: :group_elders, action: :group_admins_index
    get 'group_curators'    , controller: :group_elders, action: :group_curators_index
    get 'group_praepostors' , controller: :group_elders, action: :group_praepostors_index

    get 'person_class_schedules'    , controller: :class_schedules, action: :person
    get 'group_class_schedules/:id' , controller: :class_schedules, action: :academic_group, as: :group_class_schedules

    patch 'people/:id/move_to_group/:group_id', controller: :people, action: :move_to_group

    delete 'people/:id/remove_from_groups', controller: :people, action: :remove_from_groups
  end

  format_pdf = { format: :pdf }

  get 'export/group_list/:id', controller: :pdf_exports, action: :group_list, as: :group_list_pdf,
                               defaults: format_pdf, constraints: format_pdf

  get 'export/attendance_template/:id', controller: :pdf_exports, action: :attendance_template,
                                        as: :attendance_template_pdf, defaults: format_pdf, constraints: format_pdf
end
