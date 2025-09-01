require "rails_helper"

RSpec.describe "Location links in items", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, user:) }
  let(:location) { FactoryBot.create(:location, user:, name: "Kitchen") }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  before do
    login(user)
  end

  it "links location name to items located in that location" do
    item = FactoryBot.create(:item, user:, category:, location:)

    visit items_path
    expect(page).to have_link("Kitchen")

    click_link "Kitchen"

    expect(page).to have_css("h1", text: "Kitchen")
    expect(page).to have_text(item.name)
    expect(current_path).to eq(located_items_path(location_id: location.id))
  end
end
