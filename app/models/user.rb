class User < ApplicationRecord
  has_many :sleep_records, dependent: :destroy

  has_many :followed_users, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :followees, through: :followed_users, dependent: :destroy

  has_many :following_users, class_name: "Follow", foreign_key: "followee_id", dependent: :destroy
  has_many :followers, through: :following_users, dependent: :destroy
end
