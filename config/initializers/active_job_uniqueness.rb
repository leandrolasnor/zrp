# frozen_string_literal: true

ActiveJob::Uniqueness.configure do |config|
  config.on_conflict = :log
end
