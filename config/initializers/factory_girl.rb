if defined? FactoryGirl
  require Rails.root.join 'spec', 'support', 'helper_methods.rb'

  FactoryGirl::SyntaxRunner.send(:include, HelperMethods)
end
