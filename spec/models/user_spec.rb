require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:categories).dependent(:destroy) }
    it { should have_many(:items).dependent(:destroy) }
    it { should have_many(:locations).dependent(:destroy) }
    it { should have_many(:sessions).dependent(:destroy) }
  end

  describe ".create_with_defaults" do
    it "creates categories after creation" do
      user = User.create_with_defaults(FactoryBot.attributes_for(:user))
      categories = user.categories.pluck(:name)
      expect(categories).to match_array([
        "Books",
        "Clothing",
        "Electronics",
        "Footwear & accessories",
        "Hobbies"
      ])
    end

    it "creates locations after creation" do
      user = User.create_with_defaults(FactoryBot.attributes_for(:user))
      locations = user.locations.pluck(:name, :storage)
      expect(locations).to match_array([
        [ "Me", false ],
        [ "Bedroom", false ],
        [ "Closet", false ],
        [ "Living room", false ],
        [ "Attic", true ]
      ])
    end

    it "creates an item after creation" do
      user = User.create_with_defaults(FactoryBot.attributes_for(:user))
      items = user.items.pluck(:name)
      expect(items).to match_array([ "Towel" ])
    end
  end
end
