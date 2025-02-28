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

  describe "POST #clock_out" do
    context "when the user has an active sleep record" do
      let!(:record) { create(:sleep_record, user: user) }

      it "updates the sleep record with clock_out time" do
        post :clock_out, params: { user_id: user.id }
        record.reload

        expect(record.clock_out).not_to be_nil
        expect(response).to have_http_status(:ok)
      end
    end

    context "when the user has no active sleep record" do
      it "returns an error" do
        post :clock_out, params: { user_id: user.id }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "GET #index" do
    it "returns all sleep records of a user" do
      older_record = create(:sleep_record, user: user, created_at: 2.days.ago)
      newer_record = create(:sleep_record, user: user, created_at: 1.day.ago)

      get :index, params: { user_id: user.id }

      json_response = JSON.parse(response.body)
      expect(json_response.first["id"]).to eq(older_record.id)
      expect(json_response.last["id"]).to eq(newer_record.id)
    end
  end
end