require "rails_helper"

RSpec.describe "Create category", type: :system do
  let(:user) { FactoryBot.create(:user) }
  before { login(user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  scenario "Edit a category" do
    category = FactoryBot.create(:category, user:)
    visit "/categories"
    click_link "Edit", match: :first
    expect(page).to have_selector("h2", text: "Edit category")
    expect(page).to be_axe_clean
    fill_in "Name", with: "Books"
    click_button "Save"

    expect(page).to have_text("Books")
    expect(page).to be_axe_clean
    expect(Category.count).to eq(1)
    category.reload
    expect(category.name).to eq("Books")
    expect(category.user).to eq(user)
    expect(page).to have_text("Books")
  end
end
