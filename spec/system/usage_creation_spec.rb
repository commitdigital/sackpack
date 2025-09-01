require "rails_helper"

RSpec.describe "Usage creation", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, user: user) }
  let(:location) { FactoryBot.create(:location, user: user) }
  let!(:item) { FactoryBot.create(:item, user:, category:, location:, name: "Test Item") }

  def login(user)
    session = Session.create(user: user)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  before do
    login(user)
  end

  it "displays Use button on item" do
    visit items_path
    expect(page).to have_text("Test Item")
    expect(page).to have_link("Use")
  end

  it "navigates to usage form when Use button is clicked" do
    visit items_path
    click_link "Use"

    expect(page).to have_css("h1", text: "Record usage for Test Item")
    expect(page).to have_field("Used on", with: Date.current.strftime("%Y-%m-%d"))
    expect(page).to have_field("Note")
    expect(page).to have_button("Record usage")
    expect(page).to have_link("Cancel")
  end

  it "creates usage and redirects on valid form submission" do
    visit new_item_usage_path(item)

    fill_in "Note", with: "Used for testing"
    click_button "Record usage"

    expect(page).to have_current_path(items_path)
    expect(page).to have_text("Usage recorded")

    usage = Usage.where(item: item).last
    expect(usage.note).to eq("Used for testing")
    expect(usage.used_on).to eq(Date.current)
  end

  it "shows errors on invalid form submission" do
    visit new_item_usage_path(item)

    page.execute_script("document.querySelector('[name=\"usage[used_on]\"]').removeAttribute('required')")
    fill_in "Used on", with: ""
    click_button "Record usage"

    expect(page).to have_text("1 error prohibited this usage from being saved")
    expect(page).to have_text("Used on can't be blank")
  end

  it "cancels and returns to items index" do
    visit new_item_usage_path(item)
    click_link "Cancel"

    expect(page).to have_current_path(items_path)
  end

  it "updates item's last_used_on date" do
    visit new_item_usage_path(item)
    fill_in "Note", with: "Usage for update test"
    click_button "Record usage"

    expect(page).to have_text("Usage recorded")

    item.reload
    expect(item.last_used_on).to eq(Date.current)
  end
end
