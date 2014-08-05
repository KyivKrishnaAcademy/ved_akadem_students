class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user   = user
    @record = record
  end

  def user_activities
    if @user.present? && @user.roles.any?
      @user.roles.select(:activities).distinct.map(&:activities).flatten
    else
      []
    end
  end

  def inferred_activity(method)
    if @record.is_a?(Class)
      "#{@record.name.downcase}:#{method.to_s}"
    else
      "#{@record.class.name.downcase}:#{method.to_s}"
    end
  end

  def method_missing(name,*args)
    if name.to_s.last == '?'
      user_activities.include?(inferred_activity(name.to_s.gsub('?','')))
    else
      super
    end
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end
end
