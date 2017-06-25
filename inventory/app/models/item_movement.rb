class ItemMovement < ApplicationRecord
  has_many :container
  belongs_to :user 
end
