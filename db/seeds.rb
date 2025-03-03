# Clear existing data
User.destroy_all
SleepRecord.destroy_all
Follow.destroy_all

# Create Users
users = []
10.times do |i|
  users << User.create!(name: "User #{i + 1}")
end

# Create Follows
users.each do |user|
  followees = users.sample(rand(2..5)) - [user] # Ensure they don't follow themselves
  followees.each { |followee| Follow.create!(follower: user, followee: followee) }
end

# Create Sleep Records
users.each do |user|
  rand(5..10).times do
    clock_in = Faker::Time.between(from: 2.weeks.ago, to: Time.now)
    duration = [4, 6, 7, 8, 9].sample * 3600 # Sleep duration in seconds (4-9 hours)
    clock_out = clock_in + duration.seconds

    SleepRecord.create!(
      user: user,
      clock_in: clock_in,
      clock_out: clock_out,
      duration: duration
    )
  end
end
