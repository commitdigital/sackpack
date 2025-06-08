class User < ApplicationRecord
  has_secure_password
  has_many :categories, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  def self.create_with_defaults(attributes)
    create(attributes).tap do |user|
      if user.persisted?
        user.categories << Category.create([
          { name: "Books" },
          { name: "Clothing" },
          { name: "Electronics" },
          [ name: "Footwear & accessories" ],
          [ name: "Hobbies" ]
        ])

        user.locations << Location.create([
          { name: "Me" },
          { name: "Bedroom" },
          { name: "Closet" },
          { name: "Living room" },
          { name: "Attic", storage: true }
        ])
      end
    end
  end
end
