require "rails_helper"

RSpec.describe "Create category", type: :system do
  let(:user) { FactoryBot.create(:user) }
  before { login(user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  scenario "Create a category" do
    visit "/categories"
    click_link "New category"
    expect(page).to have_selector("h2", text: "New category")
    expect(page).to be_axe_clean
    fill_in "Name", with: "Music"
    click_button "Save"

    expect(page).to have_text("Category created")
    expect(page).to be_axe_clean
    expect(Category.count).to eq(1)
    category = Category.first
    expect(category.name).to eq("Music")
    expect(category.user).to eq(user)
    expect(page).to have_text("Music")
  end
end
