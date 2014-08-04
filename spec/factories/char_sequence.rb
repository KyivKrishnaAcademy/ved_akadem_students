FactoryGirl.define do
  sequence(:char_sequence) do |n|
    str = 'a'
    (n - 1).times { str.succ! }
    str
  end
end
