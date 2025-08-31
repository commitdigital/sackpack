class Item < ApplicationRecord
  self.strict_loading_by_default = true

  # Money fields
  monetize :purchase_value_cents
  monetize :current_value_cents

  # Associations
  belongs_to :user
  belongs_to :category
  belongs_to :location

  # Validations
  validates :expected_uses, numericality: { greater_than_or_equal_to: 0 }
  validate :category_belongs_to_user
  validate :location_belongs_to_user

  private

  def category_belongs_to_user
    return unless category_id.present?

    errors.add(:category, "must belong to the same user") unless category&.user_id == user_id
  end

  def location_belongs_to_user
    return unless location_id.present?

    errors.add(:location, "must belong to the same user") unless location&.user_id == user_id
  end
end
