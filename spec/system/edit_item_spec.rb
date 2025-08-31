require "rails_helper"

RSpec.describe "Create item", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category, user:) }
  let!(:location) { FactoryBot.create(:location, user:) }
  let!(:new_category) { FactoryBot.create(:category, name: "Books", user:) }
  before { login(user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  scenario "Edit an item" do
    item = FactoryBot.create(:item, category:, location:, user:)
    visit "/items"
    click_link "Edit", match: :first
    expect(page).to have_selector("h2", text: "Edit item")
    expect(page).to be_axe_clean
    fill_in "Name", with: "Notebook"
    fill_in "Note", with: "Personal notebook"
    select new_category.name, from: "Category"
    click_button "Save"

    expect(page).to have_text("Notebook")
    expect(page).to be_axe_clean
    expect(Item.count).to eq(1)
    item.reload
    expect(item.name).to eq("Notebook")
    expect(item.note).to eq("Personal notebook")
    expect(item.category).to eq(new_category)
    expect(item.user).to eq(user)
    expect(page).to have_text("Notebook")
  end
end
