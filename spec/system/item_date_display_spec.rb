require "rails_helper"

RSpec.describe "Item date display", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, user:) }
  let(:location) { FactoryBot.create(:location, user:) }

  def login(user)
    session = Session.create(user: user)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  before do
    login(user)
  end

  it "displays acquired_on date and Never for last_used_on when nil" do
    item = FactoryBot.create(:item, user: user, category: category, location: location,
                            name: "Test Item", acquired_on: Date.parse("2017-01-22"), last_used_on: nil)

    visit items_path
    expect(page).to have_text("2017-01-22 → Never")
  end

  it "displays both acquired_on and last_used_on dates when both present" do
    item = FactoryBot.create(:item, user: user, category: category, location: location,
                            name: "Test Item", acquired_on: Date.parse("2017-01-22"), last_used_on: Date.parse("2025-08-28"))

    visit items_path
    expect(page).to have_text("2017-01-22 → 2025-08-28")
  end

  it "displays dash when acquired_on is nil" do
    item = FactoryBot.create(:item, user: user, category: category, location: location,
                            name: "Test Item", acquired_on: nil, last_used_on: Date.parse("2025-08-28"))

    visit items_path
    expect(page).to have_text("— → 2025-08-28")
  end
end
