require "rails_helper"

RSpec.describe Item, type: :model do
  describe "associations" do
    it { should belong_to(:category) }
    it { should belong_to(:location) }
    it { should belong_to(:user) }
    it { should have_many(:usages).dependent(:delete_all) }
  end

  describe "validations" do
    it { should validate_numericality_of(:expected_uses).is_greater_than_or_equal_to(0) }

    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }
    let(:category) { FactoryBot.create(:category, user:) }
    let(:location) { FactoryBot.create(:location, user:) }
    let(:other_category) { FactoryBot.create(:category, user: other_user) }
    let(:other_location) { FactoryBot.create(:location, user: other_user) }

    it "validates category belongs to the same user" do
      item = FactoryBot.build(:item, user:, category: other_category, location:)
      expect(item).not_to be_valid
      expect(item.errors[:category]).to include("must belong to the same user")
    end

    it "validates location belongs to the same user" do
      item = FactoryBot.build(:item, user:, category:, location: other_location)
      expect(item).not_to be_valid
      expect(item.errors[:location]).to include("must belong to the same user")
    end

    it "is valid when category and location belong to the same user" do
      item = FactoryBot.build(:item, user:, category:, location:)
      expect(item).to be_valid
    end
  end
end
