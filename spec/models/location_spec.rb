require "rails_helper"

RSpec.describe Location, type: :model do
  describe "associations" do
    it { should have_many(:items).dependent(:nullify) }
    it { should belong_to(:user) }
  end
end
