if defined? FactoryBot
  require Rails.root.join 'spec/support/helper_methods.rb'

  FactoryBot::SyntaxRunner.include HelperMethods
end
