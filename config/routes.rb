VedAkademStudents::Application.routes.draw do
  devise_for :people, path: ''

  resources :people, :akadem_groups

  root 'static_pages#home'

  get 'static_pages/home'
  get 'static_pages/about'
end
