def get_person(h={})
  FactoryGirl.build(:person, h)
end

def create_person(h={})
  FactoryGirl.create(:person, h)
end

def get_akadem_group(h={})
  FactoryGirl.build(:akadem_group, h)
end

def create_akadem_group(h={})
  FactoryGirl.create(:akadem_group, h)
end
