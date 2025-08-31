require "rails_helper"

RSpec.describe "Languages", type: :request do
  describe "PATCH /language" do
    context "with valid language" do
      it "sets the session language to Japanese" do
        patch "/language", params: { language: "ja" }
        expect(session[:language]).to eq("ja")
        expect(response).to redirect_to(root_path)
      end

      it "sets the session language to Spanish" do
        patch "/language", params: { language: "es" }
        expect(session[:language]).to eq("es")
        expect(response).to redirect_to(root_path)
      end

      it "sets the session language to English" do
        patch "/language", params: { language: "en" }
        expect(session[:language]).to eq("en")
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid language" do
      it "does not set the session language" do
        patch "/language", params: { language: "fr" }
        expect(session[:language]).to be_nil
        expect(response).to redirect_to(root_path)
      end

      it "does not set the session language for empty param" do
        patch "/language", params: { language: "" }
        expect(session[:language]).to be_nil
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
