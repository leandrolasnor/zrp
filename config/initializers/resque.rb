# frozen_string_literal: true

Resque.logger = ActiveSupport::Logger.new(Rails.root.join('log', 'resque.log'), 5, 2 * 1024 * 1024)
Resque.logger.level = Logger::INFO
