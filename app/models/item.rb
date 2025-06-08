class Item < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :category
  belongs_to :location
end
