class Location < ApplicationRecord
  # Associations
  has_many :items, dependent: :nullify
  belongs_to :user
end
