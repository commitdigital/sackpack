require "rails_helper"

RSpec.describe "Language selection", type: :system do
  let(:user) { FactoryBot.create(:user) }

  def login(user)
    session = Session.create(user:)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  before do
    login(user)
  end

  it "displays language selector in footer" do
    visit root_path
    expect(page).to have_select("Language", options: [ "English", "Japanese", "Spanish" ])
  end

  it "changes language to Japanese" do
    visit root_path
    select "Japanese", from: "Language"
    expect(page).to have_text("カテゴリ") # Categories in Japanese
  end

  it "changes language to Spanish" do
    visit root_path
    select "Spanish", from: "Language"
    expect(page).to have_text("Categorías") # Categories in Spanish
  end

  it "changes language back to English" do
    visit root_path
    select "Japanese", from: "Language"
    select "英語", from: "言語" # English in Japanese, Language in Japanese
    expect(page).to have_text("Categories") # Categories in English
  end

  it "persists language selection across pages" do
    visit root_path
    select "Japanese", from: "Language"
    visit categories_path
    expect(page).to have_text("カテゴリ") # Categories in Japanese
  end

  it "sets HTML lang attribute correctly" do
    visit root_path
    expect(page).to have_css('html[lang="en"]')

    select "Japanese", from: "Language"
    expect(page).to have_css('html[lang="ja"]')

    select "スペイン語", from: "言語" # Spanish in Japanese, Language in Japanese
    expect(page).to have_css('html[lang="es"]')
  end
end
