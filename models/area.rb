class Area < ActiveRecord::Base
  belongs_to :cluster
  validates :name, :day, presence: true
end 