# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

### Ruby Version
- Ruby  `3.0.0`
- Rails `7.0.8.7`

### Configuration

### Database creation
Use `sqlite3` as the database for Active Record
- Run `rails db:migrate` to create the database.
- Run `rails db:seed` to seed database with some data.

### How to run the test suite
- Run `bundle exec rspec` to run RSpec tests.

### API Endpoints
- `POST /sleep_records/clock_in`
    - Params
        - `user_id`
    - Example
        - `localhost:3000/sleep_records/clock_in?user_id=1`

- `POST /sleep_records/clock_out`
    - Params
        - `user_id`
    - Example
        - `localhost:3000/sleep_records/clock_out?user_id=1`

- `GET /sleep_records/feed`
    - Params
        - `user_id`
        - `page`
        - `limit`
    - Example
        - `localhost:3000/sleep_records/feed?user_id=1&limit=10&page=1`

- `GET /sleep_records`
    - Params
        - `user_id`
        - `page`
        - `limit`
    - Example
        - `localhost:3000/sleep_records?user_id=1&limit=10&page=1`

- `POST /follow`
    - Params
        - `follower_id`
        - `followee_id`
    - Example
        - `localhost:3000/follow?follower_id=1&followee_id=2`

- `POST /unfollow`
    - Params
        - `follower_id`
        - `followee_id`
    - Example
        - `localhost:3000/unfollow?follower_id=1&followee_id=2`

### Performance strategy
- Indexing `user_id` in `sleep_records` table. This helps with lookup on records based on user_id.
- Pagination is used for sleep records to handle large datasets efficiently, especially for `index` and `feed` actions.
- Caching is also used for `index` and `feed` actions to reduce database load and speed up responses.

### Potential Improvements
- Increase database connection pool size to support
- Add background jobs for long running tasks
- Add rate limit to prevent API abuse