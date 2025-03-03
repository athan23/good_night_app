require 'rails_helper'

RSpec.describe SleepRecordsController, type: :controller do
  render_views

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
    before do
      create_list(:sleep_record, 35, user: user, clock_in: 8.hours.ago, clock_out: 1.hour.ago)
    end

    it "returns all sleep records of a user" do
      get :index, params: { format: :json, user_id: user.id, page: 3, limit: 10 }

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(json_response["records"].size).to be <= Pagy::DEFAULT[:limit]
      expect(json_response["pagination"]).to have_key("total_pages")
      expect(json_response["pagination"]).to have_key("current_page")
      expect(json_response["pagination"]).to have_key("next_page")
      expect(json_response["pagination"]).to have_key("prev_page")
    end
  end

  describe "GET #feed" do
    let(:followee1) { create(:user) }
    let(:followee2) { create(:user) }
    let(:followee3) { create(:user) }

    before do
      create(:follow, follower: user, followee: followee1)
      create(:follow, follower: user, followee: followee2)
      create(:follow, follower: user, followee: followee3)

      create(:sleep_record, user: followee1, clock_in: 33.hours.ago, clock_out: 25.hours.ago)
      create(:sleep_record, user: followee2, clock_in: 34.hours.ago, clock_out: 27.hours.ago)
      create(:sleep_record, user: followee3, clock_in: 7.hours.ago, clock_out: 3.hours.ago)
      create(:sleep_record, user: followee1, clock_in: 6.hours.ago, clock_out: 2.hours.ago)
      create(:sleep_record, user: followee2, clock_in: 12.hours.ago, clock_out: 4.hours.ago)
    end

    it "returns sleep records of followed users from the past week sorted by sleep length" do
      get :feed, params: { format: :json, user_id: user.id, page: 1 }

      json_response = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)

      records = json_response["records"]
      expect(records.size).to be <= Pagy::DEFAULT[:limit]

      start_of_last_week = 1.week.ago.beginning_of_week
      end_of_last_week = 1.week.ago.end_of_week

      # Check if sleep records are from the previous week
      records.each do |record|
        clock_out = Time.parse(record["clock_out"])
        expect(clock_out).to be >= start_of_last_week
        expect(clock_out).to be <= end_of_last_week
      end

      # Check if sleep records are sorted by sleep duration
      durations = records.map { |r| r["duration"].to_i }
      expect(durations).to eq(durations.sort.reverse)

      expect(json_response["pagination"]).to have_key("total_pages")
      expect(json_response["pagination"]).to have_key("current_page")
      expect(json_response["pagination"]).to have_key("next_page")
      expect(json_response["pagination"]).to have_key("prev_page")
    end
  end
end