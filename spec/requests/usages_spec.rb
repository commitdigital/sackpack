require "rails_helper"

RSpec.describe "Usages", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:category) { FactoryBot.create(:category, user: user) }
  let(:location) { FactoryBot.create(:location, user: user) }
  let(:item) { FactoryBot.create(:item, user: user, category: category, location: location) }
  let(:other_item) { FactoryBot.create(:item, user: other_user, category: FactoryBot.create(:category, user: other_user), location: FactoryBot.create(:location, user: other_user)) }

  before { login(user) }

  def login(user)
    session = Session.create(user: user)
    cookies = Struct.new(:signed).new({ session_id: session.id })
    allow_any_instance_of(ApplicationController).to receive(:cookies).and_return(cookies)
  end

  describe "GET /items/:item_id/usages/new" do
    it "renders the new usage form" do
      get new_item_usage_path(item)
      expect(response).to have_http_status(:success)
    end

    it "prevents access to other user's item" do
      get new_item_usage_path(other_item)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /items/:item_id/usages" do
    let(:valid_params) { { usage: { used_on: Date.current, note: "Test usage" } } }
    let(:invalid_params) { { usage: { used_on: nil, note: "Test usage" } } }

    it "creates a new usage with valid params" do
      expect {
        post item_usages_path(item), params: valid_params
      }.to change { item.usages.count }.by(1)

      expect(response).to redirect_to(items_path)
      expect(flash[:notice]).to be_present
    end

    it "does not create usage with invalid params" do
      expect {
        post item_usages_path(item), params: invalid_params
      }.not_to change { Usage.count }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "prevents creating usage for other user's item" do
      post item_usages_path(other_item), params: valid_params
      expect(response).to have_http_status(:not_found)
    end

    it "updates item's last_used_on when usage date is more recent" do
      item.update!(last_used_on: 1.week.ago)

      post item_usages_path(item), params: { usage: { used_on: Date.current, note: "Recent usage" } }

      item.reload
      expect(item.last_used_on).to eq(Date.current)
    end

    it "does not update item's last_used_on when usage date is older" do
      item.update!(last_used_on: Date.current)

      post item_usages_path(item), params: { usage: { used_on: 1.week.ago, note: "Old usage" } }

      item.reload
      expect(item.last_used_on).to eq(Date.current)
    end
  end
end
