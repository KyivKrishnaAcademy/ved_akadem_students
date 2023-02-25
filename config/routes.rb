require 'sidekiq/web'

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for(
    :people,
    path: '',
    controllers: { registrations: 'users/registrations' },
    path_names: { sign_up: 'register' }
  )

  authenticate :person, ->(p) { p.can_act?('sidekiq:admin') } do
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      mount_devise_token_auth_for 'Person', at: 'auth', skip: %i[passwords registrations]

      resources :people, only: :index
    end
  end

  resources :academic_groups do
    resources :statistics, only: :index
  end

  resources :group_participations, only: :destroy
  resources :class_schedules, only: %i[new create edit update index destroy]
  resources :questionnaires, only: %i[index show new]
  resources :study_applications, only: %i[create destroy]
  resources :answers, only: %i[update edit]
  resources :certificate_imports, only: %i[new create]
  resources :certificate_templates, only: %i[new create edit update index destroy]
  resources :certificate_template_fonts, only: %i[new create edit update index destroy]

  resources :people do
    get '/journal', action: :journal

    resources :notes, only: %i[new create edit update destroy]
  end

  resource :subscriptions, only: %i[edit update]

  resources :courses do
    resources :examinations, only: %i[new create edit update show destroy]
  end

  resources :programs, only: %i[new create edit update index]

  post '/academic_groups/:id/graduate', controller: :academic_groups, action: :graduate, as: :graduate_academic_group

  scope module: :users do
    get  '/remind_email' => 'emails#new'
    post '/show_emails'  => 'emails#create'
  end

  get '/unsubscribe/:code/:email', controller: :unsubscribes, action: :edit, as: :unsubscribe
  delete '/unsubscribe/:code/:email', controller: :unsubscribes, action: :destroy

  root 'static_pages#home'

  get 'static_pages/home'
  get 'changelog', controller: :static_pages, action: :changelog
  get 'privacy_agreement', controller: :static_pages, action: :privacy_agreement

  get 'locales/toggle'

  get   'image/crop/:id', controller: :crops, action: :crop_image, as: :crop_image
  patch 'image/update/:id', controller: :crops, action: :update_image, as: :update_image

  get 'people/show_photo/:version/:id', controller: :people, action: :show_photo

  namespace :ui do
    resources :academic_groups,  only: :index
    resources :classrooms,       only: :index
    resources :courses,          only: :index
    resources :teacher_profiles, only: :index
    resources :examination_results, only: %i[create update destroy]
    resources :schedule_attendances, only: %i[index create update destroy]

    get 'group_admins', controller: :group_elders, action: :group_admins_index
    get 'group_curators', controller: :group_elders, action: :group_curators_index
    get 'group_praepostors', controller: :group_elders, action: :group_praepostors_index

    resources :class_schedules, only: :index

    get 'person_class_schedules', controller: :class_schedules, action: :person
    get 'group_class_schedules/:id', controller: :class_schedules, action: :academic_group, as: :group_class_schedules

    patch 'people/:id/move_to_group/:group_id', controller: :people, action: :move_to_group
  end

  format_pdf = { format: :pdf }

  get 'export/group_list/:id', controller: :pdf_exports, action: :group_list, as: :group_list_pdf,
                               defaults: format_pdf, constraints: format_pdf

  get 'export/attendance_template/:id', controller: :pdf_exports, action: :attendance_template,
                                        as: :attendance_template_pdf, defaults: format_pdf, constraints: format_pdf

  get 'export/certificate/:serial_id', controller: :pdf_exports, action: :certificate,
                                       as: :certificate_pdf, defaults: format_pdf, constraints: format_pdf

  get 'certificate_templates/:id/preview', controller: :pdf_exports,
                                           action: :certificate_template_preview,
                                           as: :certificate_template_preview_pdf,
                                           defaults: format_pdf,
                                           constraints: format_pdf

  resource :journal, only: :show

  namespace :webhooks do
    post 'mailgun/complained', controller: :mailgun, action: :complained
    post 'mailgun/failed', controller: :mailgun, action: :failed
  end

  get 'statistics/yearly_active_students/:start_year/:end_year', controller: :statistics,
                                                                 action: :yearly_active_students,
                                                                 as: :statistics_yearly_active_students

  get 'statistics/yearly_certificates/:start_year/:end_year', controller: :statistics,
                                                              action: :yearly_certificates,
                                                              as: :statistics_yearly_certificates
end
# rubocop:enable Metrics/BlockLength
