class LocalesController < ApplicationController
  skip_before_action :authenticate_person!

  def toggle
    $locale = I18n.locale == :ru ? :uk : :ru
    if current_person
      $person = Person.find(current_person.id)
      $person.locale = $locale
      $person.save
    else
      session[:locale] = $locale
    end

    redirect_to :back
  end
end
