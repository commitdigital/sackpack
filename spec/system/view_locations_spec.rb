require "rails_helper"

RSpec.describe "View locations", type: :system do
  let(:user) { FactoryBot.create(:user) }
  before { login(user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  scenario "View locations" do
    FactoryBot.create(:location, name: "Kitchen", user:)
    visit "/"
    click_link "Locations"
    expect(page).to be_axe_clean
    expect(page).to have_css "h1", text: "Locations"
    expect(page).to have_content "Kitchen"
  end
end
