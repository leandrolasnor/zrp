# frozen_string_literal: true

module RemoveFromIndex
  class Service
    extend Dry::Initializer

    option :model, type: Types::Coercible::String, reader: :private
    option :id, type: Types::Coercible::Integer, reader: :private

    def call
      monad = Monad.new(model: model.constantize, id:).call
      Job.set(wait: 5.seconds).perform_later(model:, id:) if monad.failure?
      AppEvents.publish('hero.removed_from_index', model:, id:, document: monad.value!) if monad.success?
    end
  end

  class Job < ApplicationJob
    queue_as :critical
    unique :until_and_while_executing, lock_ttl: 5.seconds
    def perform(...) = Service.new(...).call
  end
end
