require "rails_helper"

RSpec.describe Category, type: :model do
  describe "associations" do
    it { should have_many(:items).dependent(:nullify) }
    it { should belong_to(:user) }
  end
end
