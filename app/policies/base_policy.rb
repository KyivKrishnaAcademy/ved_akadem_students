class BasePolicy
  attr_reader :user, :record

  Scope = Struct.new(:user, :scope) do
    def resolve
      scope.all
    end
  end

  def initialize(user, record)
    @user   = user
    @record = record
  end

  def user_activities
    @user_activities ||= if @user.present? && @user.roles.any?
      @user.roles.select(:activities).distinct.map(&:activities).flatten
    else
      []
    end
  end

  def inferred_activity(method)
    if @record.is_a?(Class)
      "#{@record.name.underscore}:#{method}"
    else
      "#{@record.class.name.underscore}:#{method}"
    end
  end

  # rubocop:disable Style/MissingRespondToMissing
  def method_missing(name, *args)
    if name.to_s.last == '?'
      user_activities.include?(inferred_activity(name.to_s.delete('?')))
    else
      super
    end
  end
  # rubocop:enable Style/MissingRespondToMissing

  def scope
    Pundit.policy_scope!(user, record.class)
  end
end
