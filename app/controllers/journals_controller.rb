class JournalsController < ApplicationController
  def show
    @versions = PaperTrail::Version.order(created_at: :desc).page(params[:page])

    authorize PaperTrail::Version

    @users = Person
               .where(id: @versions.map(&:whodunnit).uniq.compact)
               .map { |p| [p.id.to_s, p] }
               .to_h
  end
end
