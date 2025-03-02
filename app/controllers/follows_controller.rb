class FollowsController < ApplicationController
  before_action :set_users

  def follow
    if @follower.followees.include?(@followee)
      return render json: { error: "Already following this user" }, status: :bad_request
    end

    @follower.followed_users.create!(followee: @followee)
    render json: { message: "Followed successfully" }
  end

  def unfollow
    follow = @follower.followed_users.find_by(followee: @followee)
    return render json: { error: "Not following this user" }, status: :bad_request unless follow

    follow.destroy
    render json: { message: "Unfollowed successfully" }
  end

  private

  def set_users
    @follower = User.find(params[:follower_id])
    @followee = User.find(params[:followee_id])
  end
end