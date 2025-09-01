require "rails_helper"

RSpec.describe "Items located by location", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, user:) }
  let(:other_category) { FactoryBot.create(:category, user:) }
  let(:location) { FactoryBot.create(:location, user:) }
  let(:other_location) { FactoryBot.create(:location, user:) }
  let(:other_user_location) { FactoryBot.create(:location, user: other_user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  before do
    login(user)
  end

  it "shows only items in the specified location" do
    item_in_location = FactoryBot.create(:item, user:, category: category, location: location)
    item_in_other_location = FactoryBot.create(:item, user:, category: other_category, location: other_location)

    visit located_items_path(location_id: location.id)

    expect(page).to have_text(item_in_location.name)
    expect(page).not_to have_text(item_in_other_location.name)
  end

  it "displays location name as heading" do
    visit located_items_path(location_id: location.id)
    expect(page).to have_css("h1", text: location.name)
  end

  it "prevents access to other user's location" do
    visit located_items_path(location_id: other_user_location.id)
    expect(page).to have_text("ActiveRecord::RecordNotFound")
  end

  it "groups items by category within the location" do
    item1 = FactoryBot.create(:item, user:, category: category, location:, name: "Item 1")
    item2 = FactoryBot.create(:item, user:, category: other_category, location:, name: "Item 2")

    visit located_items_path(location_id: location.id)

    expect(page).to have_css("h2", text: category.name)
    expect(page).to have_css("h2", text: other_category.name)
    expect(page).to have_text("Item 1")
    expect(page).to have_text("Item 2")
  end

  it "excludes discarded items from location view" do
    active_item = FactoryBot.create(:item, user:, category:, location:, name: "Active Item")
    discarded_item = FactoryBot.create(:item, user:, category:, location:, name: "Discarded Item", discarded_on: Date.current)

    visit located_items_path(location_id: location.id)

    expect(page).to have_text("Active Item")
    expect(page).not_to have_text("Discarded Item")
  end
end
