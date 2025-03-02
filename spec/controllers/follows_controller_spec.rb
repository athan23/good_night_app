require 'rails_helper'

RSpec.describe FollowsController, type: :controller do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }

  describe "POST #follow" do
    context "when the user is not already following the other user" do
      it "successfully follows the other user" do
        expect {
          post :follow, params: { follower_id: user1.id, followee_id: user2.id }
        }.to change(Follow, :count).by(1)

        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user is already following the other user" do
      before { create(:follow, follower: user1, followee: user2) }

      it "returns an error" do
        post :follow, params: { follower_id: user1.id, followee_id: user2.id }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "POST #unfollow" do
    context "when the user is following" do
      before { create(:follow, follower: user1, followee: user2) }

      it "removes the follow relationship" do
        expect {
          post :unfollow, params: { follower_id: user1.id, followee_id: user2.id }
        }.to change(Follow, :count).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user is not following" do
      it "returns an error" do
        post :unfollow, params: { follower_id: user1.id, followee_id: user2.id }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end