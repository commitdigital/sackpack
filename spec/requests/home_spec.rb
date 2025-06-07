require "rails_helper"

RSpec.describe "Home", type: :request do
  let(:user) { FactoryBot.create(:user) }
  before { login(user) }

  def login(user)
    session = Session.new(user:)
    allow(Current).to receive(:session).and_return(session)
    allow(Current).to receive(:user).and_return(user)
  end

  describe "GET /" do
    it "returns HTTP success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end
end
