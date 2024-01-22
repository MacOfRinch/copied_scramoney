require 'rails_helper'

RSpec.describe "InvitedUsers", type: :request do
  describe "GET /new" do
    it "returns http success" do
      get "/invited_users/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/invited_users/create"
      expect(response).to have_http_status(:success)
    end
  end

end
