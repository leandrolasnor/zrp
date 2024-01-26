# frozen_string_literal: true

MeiliSearch::Rails.configuration = {
  meilisearch_url: ENV.fetch('MEILISEARCH_URL'),
  meilisearch_api_key: ENV.fetch('MEILISEARCH_ACCESS_KEY'),
  pagination_backend: :kaminari,
  timeout: 2,
  max_retries: 1,
  active: !Rails.env.test?
}
