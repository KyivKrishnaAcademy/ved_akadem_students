FactoryGirl.define do
  factory :note do
    person
    date '2018-08-03'
    message 'MyText'
  end
end
