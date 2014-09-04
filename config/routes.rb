VedAkademStudents::Application.routes.draw do
  devise_for :people, path: '', controllers: { registrations: 'users/registrations' }, path_names: { sign_up: 'register' }

  resources :people, :akadem_groups
  resources :study_applications, only: [:create, :destroy]

  scope module: :users do
    get   '/remind_email' => 'emails#new'
    post  '/show_emails'  => 'emails#update'
  end

  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/about'

  get 'locales/toggle'

  get 'image/crop/:id', controller: :crops, action: :crop_image, as: :crop_image
  patch 'image/update/:id', controller: :crops, action: :update_image, as: :update_image

  get 'people/show_photo/:version/:id', controller: :people, action: :show_photo
  get 'people/show_passport/:id', controller: :people, action: :show_passport
end
