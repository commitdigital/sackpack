require "rails_helper"

RSpec.describe Item, type: :model do
  describe "associations" do
    it { should belong_to(:category) }
    it { should belong_to(:location) }
    it { should belong_to(:user) }
  end
end
