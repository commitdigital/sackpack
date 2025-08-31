require "rails_helper"

RSpec.describe "View items", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:category) { FactoryBot.create(:category, name: "Electronics", user:) }
  let!(:location) { FactoryBot.create(:location, name: "Desk", user:) }
  before { login(user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  scenario "View items" do
    FactoryBot.create(:item, name: "Phone", category:, location:, user:)
    visit "/"
    click_link "Items"
    expect(page).to be_axe_clean
    expect(page).to have_css "h1", text: "Items"
    expect(page).to have_content "Phone"
    expect(page).to have_content "Electronics"
    expect(page).to have_content "Desk"
  end
end
