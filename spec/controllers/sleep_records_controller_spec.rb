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

  describe "GET #feed" do
    let(:followee1) { create(:user) }
    let(:followee2) { create(:user) }

    before do
      create(:follow, follower: user, followee: followee1)
      create(:follow, follower: user, followee: followee2)

      create(:sleep_record, user: followee1, clock_in: 8.hours.ago, clock_out: 1.hour.ago)
      create(:sleep_record, user: followee2, clock_in: 7.hours.ago, clock_out: 2.hours.ago)
    end

    it "returns sleep records of followed users from the past week sorted by sleep length" do
      get :feed, params: { user_id: user.id }

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response.size).to eq(2)

      sleep_lengths = json_response.map { |r| r["clock_out"].to_time - r["clock_in"].to_time }
      expect(sleep_lengths).to eq(sleep_lengths.sort.reverse) # Ensure longest sleep first
    end
  end
end