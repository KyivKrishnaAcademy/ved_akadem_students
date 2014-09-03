class Program < ActiveRecord::Base
  validates :title, presence: true
end
