require "rails_helper"

RSpec.describe "Application", type: :request do
  describe "locale detection" do
    context "when session language is set" do
      it "uses session language over browser detection" do
        get root_path, headers: { "HTTP_ACCEPT_LANGUAGE" => "ja,en;q=0.9" }
        patch "/language", params: { language: "es" }
        get root_path
        expect(I18n.locale).to eq(:es)
      end
    end

    context "when session language is not set" do
      it "detects Japanese from browser" do
        get root_path, headers: { "HTTP_ACCEPT_LANGUAGE" => "ja,en;q=0.9" }
        expect(I18n.locale).to eq(:ja)
      end

      it "detects Spanish from browser" do
        get root_path, headers: { "HTTP_ACCEPT_LANGUAGE" => "es,en;q=0.9" }
        expect(I18n.locale).to eq(:es)
      end

      it "detects English from browser" do
        get root_path, headers: { "HTTP_ACCEPT_LANGUAGE" => "en,ja;q=0.9" }
        expect(I18n.locale).to eq(:en)
      end

      it "falls back to English for unsupported language" do
        get root_path, headers: { "HTTP_ACCEPT_LANGUAGE" => "fr,de;q=0.9" }
        expect(I18n.locale).to eq(:en)
      end

      it "falls back to English when no Accept-Language header" do
        get root_path
        expect(I18n.locale).to eq(:en)
      end
    end
  end
end
