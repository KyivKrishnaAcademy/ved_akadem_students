def get_person(h={})
  FactoryGirl.build(:person, h)
end

def create_person(h={})
  FactoryGirl.create(:person, h)
end
