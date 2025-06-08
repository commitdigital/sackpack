require "rails_helper"

RSpec.describe "Create account", type: :system do
  scenario "Create an account happy path" do
    visit "/"
    click_link "Create account"
    expect(page).to be_axe_clean
    expect(page).to have_selector("h1", text: "Create account")
    fill_in "Email address", with: "newuser@example.com"
    fill_in "Password", with: "password"
    click_button "Create account"

    expect(page).to have_text("Account created")
    expect(page).to be_axe_clean
    expect(User.count).to eq(1)
    user = User.first
    expect(user.email_address).to eq("newuser@example.com")

    expect(user.categories).not_to be_empty
    expect(user.locations).not_to be_empty
  end
end
