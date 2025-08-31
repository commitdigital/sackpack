require "rails_helper"

RSpec.describe "Create location", type: :system do
  let(:user) { FactoryBot.create(:user) }
  before { login(user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  scenario "Edit a location" do
    location = FactoryBot.create(:location, user:)
    visit "/locations"
    click_link "Edit"
    expect(page).to be_axe_clean
    expect(page).to have_selector("h2", text: "Edit location")
    fill_in "Name", with: "Kitchen"
    check "Storage location"
    click_button "Save"

    expect(page).to have_text("Kitchen")
    expect(page).to be_axe_clean
    expect(Location.count).to eq(1)
    location.reload
    expect(location.name).to eq("Kitchen")
    expect(location.storage).to be(true)
    expect(location.user).to eq(user)
    expect(page).to have_text("Kitchen")
  end
end
