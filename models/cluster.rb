class Cluster < ActiveRecord::Base
  validates :name, presence: true
end 