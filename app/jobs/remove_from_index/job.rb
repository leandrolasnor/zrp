# frozen_string_literal: true

module RemoveFromIndex
  class Service
    extend Dry::Initializer

    option :model, type: Types::Coercible::String, reader: :private
    option :id, type: Types::Coercible::Integer, reader: :private

    def call
      monad = Monad.new(model: model.constantize, id:).call
      raise ApplicationJob::RetryableError, monad.exception.message if monad.failure?

      AppEvents.publish('hero_removed_from_index', model:, id:, document: monad.value!)
    end
  end

  class Job < ApplicationJob
    queue_as :critical
    unique :until_and_while_executing, lock_ttl: 5.seconds
    retry_on ApplicationJob::RetryableError, attempts: ApplicationJob::RETRY_ATTEMPTS, wait: :polynomially_longer do |job, error|
      Rails.logger.error("RemoveFromIndex::Job descartado após #{job.executions} tentativas (arguments=#{job.arguments.inspect}): #{error.message}")
    end
    def perform(...) = Service.new(...).call
  end
end
