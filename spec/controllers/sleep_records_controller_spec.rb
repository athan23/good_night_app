require 'rails_helper'

RSpec.describe SleepRecordsController, type: :controller do
  let(:user) { create(:user) }

  describe "POST #clock_in" do
    context "when the user has no active sleep record" do
      it "creates a new sleep record" do
        expect {
          post :clock_in, params: { user_id: user.id }
        }.to change(SleepRecord, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "when the user already has an active sleep record" do
      before { create(:sleep_record, user: user) }

      it "returns an error" do
        post :clock_in, params: { user_id: user.id }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end