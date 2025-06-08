class User < ApplicationRecord
  has_secure_password
  has_many :locations, dependent: :destroy
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def self.create_with_defaults(attributes)
    create(attributes).tap do |user|
      if user.persisted?
        user.locations << Location.create(name: "Me")
        user.locations << Location.create(name: "Bedroom")
        user.locations << Location.create(name: "Closet")
        user.locations << Location.create(name: "Living room")
        user.locations << Location.create(name: "Attic", storage: true)
      end
    end
  end
end
