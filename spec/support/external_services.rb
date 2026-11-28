# frozen_string_literal: true

# Tests must not depend on external services being up.
# ActiveJob::Uniqueness uses Redlock on enqueue; its test lock manager replaces
# Redis with an in-memory lock. Meilisearch is already disabled in test env.
ActiveJob::Uniqueness.test_mode! if Rails.env.test?
