class FollowsController < ApplicationController
  before_action :set_users

  def follow
    if @follower.followees.include?(@followee)
      return render json: { error: "Already following this user" }, status: :bad_request
    end

    @follower.followed_users.create!(followee: @followee)
    render json: { message: "Followed successfully" }
  end

  private

  def set_users
    @follower = User.find(params[:follower_id])
    @followee = User.find(params[:followee_id])
  end
end