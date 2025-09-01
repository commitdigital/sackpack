require "rails_helper"

RSpec.describe Usage, type: :model do
  describe "associations" do
    it { should belong_to(:item) }
  end

  describe "validations" do
    it { should validate_presence_of(:used_on) }
  end
end
