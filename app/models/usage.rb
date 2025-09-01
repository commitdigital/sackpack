class Usage < ApplicationRecord
  self.strict_loading_by_default = true

  # Associations
  belongs_to :item

  # Validations
  validates :used_on, presence: true
end
