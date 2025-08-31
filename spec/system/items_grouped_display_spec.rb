require "rails_helper"

RSpec.describe "Items grouped display", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:electronics_category) { FactoryBot.create(:category, name: "Electronics", user:) }
  let!(:books_category) { FactoryBot.create(:category, name: "Books", user:) }
  let!(:clothing_category) { FactoryBot.create(:category, name: "Clothing", user:) }
  let!(:location) { FactoryBot.create(:location, name: "Desk", user:) }
  before { login(user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  scenario "View items grouped by category in alphabetical order" do
    FactoryBot.create(:item, name: "Phone", category: electronics_category, location:, user:)
    FactoryBot.create(:item, name: "Novel", category: books_category, location:, user:)
    FactoryBot.create(:item, name: "Laptop", category: electronics_category, location:, user:)

    visit "/items"
    expect(page).to be_axe_clean

    category_headings = page.all("h2.category-heading").map(&:text)
    expect(category_headings).to eq([ "Books", "Electronics" ])

    within("section:nth-child(1)") do
      expect(page).to have_css "h2", text: "Books"
      expect(page).to have_content "Novel"
    end

    within("section:nth-child(2)") do
      expect(page).to have_css "h2", text: "Electronics"
      expect(page).to have_content "Phone"
      expect(page).to have_content "Laptop"
    end

    expect(page).not_to have_content "Clothing"
  end
end
