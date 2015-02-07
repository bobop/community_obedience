class Nation < ActiveRecord::Base
  belongs_to :province
  validates :content, :day, presence: true
end 