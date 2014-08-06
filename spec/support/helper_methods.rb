def login_as_admin(admin=nil)
  @admin = admin
  @admin ||= create(:person, :admin)
  login_as(@admin, scope: :person)
  visit '/'
end

def login_as_user(user=nil)
  @user = user
  @user ||= create(:person)
  login_as(@user, scope: :person)
  visit '/'
end
