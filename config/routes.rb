VedAkademStudents::Application.routes.draw do
  devise_for :people, path: '', controllers: { registrations: 'users/registrations' }, path_names: { sign_up: 'register' }

  resources :people, :akadem_groups

  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/about'

  get 'locales/toggle'

  get 'people/show_photo/:version/:id', controller: :people, action: :show_photo
end
