require "rails_helper"

RSpec.describe "Sessions", type: :system do
  scenario "Sign in and sign out" do
    FactoryBot.create(:user, email_address: "user@example.com", password: "topsecret")

    visit "/session/new"
    expect(page).to be_axe_clean

    fill_in "Email address", with: "user@example.com"
    fill_in "Password", with: "topsecret"
    click_button "Sign in"

    expect(page).to have_content("Welcome to Sackpack!")
    expect(page).to be_axe_clean

    expect(page).not_to have_content("Sign in")
    expect(page).to have_content("Sign out")

    click_link "Sign out"

    expect(page).to have_content("Sign in")
    expect(page).not_to have_content("Sign out")
  end

  scenario "Sign in with invalid credentials" do
    visit "/session/new"
    expect(page).to be_axe_clean

    fill_in "Email address", with: "user@example.com"
    fill_in "Password", with: "wrongpassword"
    click_button "Sign in"

    expect(page).to have_content("Try another email address or password.")
    expect(page).to be_axe_clean
  end
end
