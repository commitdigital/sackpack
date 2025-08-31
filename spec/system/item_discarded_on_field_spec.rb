require "rails_helper"

RSpec.describe "Item discarded_on field", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category, user:) }
  let!(:location) { FactoryBot.create(:location, user:) }
  before { login(user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  scenario "Set discarded_on date when creating item" do
    visit "/items"
    click_link "New item"
    fill_in "Name", with: "Old Phone"
    select category.name, from: "Category"
    select location.name, from: "Location"
    fill_in "Discarded on", with: "01/01/2025"
    click_button "Save"

    expect(page).to have_text("Item created")
    item = Item.first
    expect(item.name).to eq("Old Phone")
    expect(item.discarded_on).to eq(Date.new(2025, 1, 1))
  end
end
