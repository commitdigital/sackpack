require "rails_helper"

RSpec.describe "Create item", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category, user:) }
  let!(:location) { FactoryBot.create(:location, user:) }
  before { login(user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  scenario "Create an item" do
    visit "/items"
    click_link "New item"
    expect(page).to be_axe_clean
    expect(page).to have_selector("h2", text: "New item")
    fill_in "Name", with: "Laptop"
    fill_in "Note", with: "Work laptop"
    select category.name, from: "Category"
    select location.name, from: "Location"
    fill_in "Purchase value (cents)", with: "150000"
    fill_in "Current value (cents)", with: "100000"
    click_button "Save"

    expect(page).to have_text("Item created")
    expect(page).to be_axe_clean
    expect(Item.count).to eq(1)
    item = Item.first
    expect(item.name).to eq("Laptop")
    expect(item.note).to eq("Work laptop")
    expect(item.category).to eq(category)
    expect(item.location).to eq(location)
    expect(item.user).to eq(user)
    expect(page).to have_text("Laptop")
  end
end
