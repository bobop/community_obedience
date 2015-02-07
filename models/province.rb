class Province < ActiveRecord::Base
  has_many :nations
  validates :name, presence: true
end 