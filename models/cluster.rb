class Cluster < ActiveRecord::Base
  has_many :areas
  validates :name, presence: true
end 