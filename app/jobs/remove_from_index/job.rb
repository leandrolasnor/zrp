# frozen_string_literal: true

module RemoveFromIndex
  class Service
    extend Dry::Initializer

    param :destroyed, type: Types::Instance(Object), reader: :private
    option :event_name, type: Types::Coercible::String, default: -> { 'hero.removed_from_index' }, reader: :private
    option :monad,
           type: Types::Interface(:call),
           default: -> { Monad.new(index: destroyed.class.index, id: object.id).call },
           reader: :private

    def call
      AppEvents.publish(event_name, hero: object) if monad.success?
      Job.set(wait: 5.minutes).perform_later(object) if monad.failure?
    end
  end

  class Job < ApplicationJob
    queue_as :critical
    unique :until_and_while_executing, lock_ttl: 5.seconds
    def perform(...) = Service.new(...).call
  end
end
