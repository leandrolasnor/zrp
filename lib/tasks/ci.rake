# frozen_string_literal: true

namespace :ci do
  desc 'Run the RSpec suite'
  task spec: :environment do
    sh({ 'COVERAGE_MINIMUM' => ENV.fetch('COVERAGE_MINIMUM', '85') }, 'bundle exec rspec')
  end

  desc 'Run RuboCop'
  task lint: :environment do
    sh 'bundle exec rubocop'
  end

  desc 'Run the full CI pipeline (specs and lint)'
  task all: %i[spec lint]
end
