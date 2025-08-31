class Location < ApplicationRecord
  self.strict_loading_by_default = true

  # Associations
  has_many :items, dependent: :nullify
  belongs_to :user
end
