require "rails_helper"

RSpec.describe "Items exclude discarded", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:electronics_category) { FactoryBot.create(:category, name: "Electronics", user:) }
  let!(:books_category) { FactoryBot.create(:category, name: "Books", user:) }
  let!(:location) { FactoryBot.create(:location, name: "Desk", user:) }
  before { login(user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  scenario "Exclude discarded items from display" do
    active_item = FactoryBot.create(:item, name: "Phone", category: electronics_category, location:, user:, discarded_on: nil)
    discarded_item = FactoryBot.create(:item, name: "Old Laptop", category: electronics_category, location:, user:, discarded_on: Date.current)
    book_item = FactoryBot.create(:item, name: "Novel", category: books_category, location:, user:, discarded_on: nil)
    discarded_book = FactoryBot.create(:item, name: "Old Magazine", category: books_category, location:, user:, discarded_on: Date.current)

    visit "/items"
    expect(page).to be_axe_clean

    expect(page).to have_content "Phone"
    expect(page).to have_content "Novel"
    expect(page).not_to have_content "Old Laptop"
    expect(page).not_to have_content "Old Magazine"

    category_headings = page.all("h2.category-heading").map(&:text)
    expect(category_headings).to eq([ "Books", "Electronics" ])
  end

  scenario "Hide categories that only contain discarded items" do
    discarded_item = FactoryBot.create(:item, name: "Old Laptop", category: electronics_category, location:, user:, discarded_on: Date.current)
    active_book = FactoryBot.create(:item, name: "Novel", category: books_category, location:, user:, discarded_on: nil)

    visit "/items"
    expect(page).to be_axe_clean

    expect(page).to have_content "Novel"
    expect(page).not_to have_content "Old Laptop"
    expect(page).not_to have_content "Electronics"

    category_headings = page.all("h2.category-heading").map(&:text)
    expect(category_headings).to eq([ "Books" ])
  end
end
