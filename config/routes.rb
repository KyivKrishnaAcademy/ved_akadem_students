Rails.application.routes.draw do
  devise_for :people, path: '', controllers: { registrations: 'users/registrations' }, path_names: { sign_up: 'register' }

  resources :people, :courses, :academic_groups
  resources :class_schedules   , only: [:new, :create, :edit, :update, :index, :destroy]
  resources :study_applications, only: [:create, :destroy]
  resources :answers           , only: [:update, :edit]

  scope module: :users do
    get  '/remind_email' => 'emails#new'
    post '/show_emails'  => 'emails#create'
  end

  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/about'
  get 'privacy_agreement' => 'static_pages#privacy_agreement'

  get 'locales/toggle'

  get   'image/crop/:id'  , controller: :crops, action: :crop_image  , as: :crop_image
  patch 'image/update/:id', controller: :crops, action: :update_image, as: :update_image

  get    'people/show_photo/:version/:id'    , controller: :people, action: :show_photo
  get    'people/show_passport/:id'          , controller: :people, action: :show_passport
  patch  'people/:id/move_to_group/:group_id', controller: :people, action: :move_to_group, constraints: { format: :js }
  delete 'people/:id/remove_from_groups'     , controller: :people, action: :remove_from_groups, constraints: { format: :js }

  namespace :ui do
    resources :academic_groups,  only: :index
    resources :classrooms,       only: :index
    resources :courses,          only: :index
    resources :teacher_profiles, only: :index

    get 'group_admins'      , controller: :group_elders, action: :group_admins_index
    get 'group_curators'    , controller: :group_elders, action: :group_curators_index
    get 'group_praepostors' , controller: :group_elders, action: :group_praepostors_index
  end

  format_pdf = { format: :pdf }

  get 'export/group_list/:id', controller: :pdf_exports, action: :group_list, as: :group_list_pdf,
                                     defaults: format_pdf, constraints: format_pdf
end
