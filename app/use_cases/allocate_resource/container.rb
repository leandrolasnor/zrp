# frozen_string_literal: true

module AllocateResource
  class Container
    extend Dry::Container::Mixin

    register 'steps.find', -> { Steps::Find.new }
    register 'steps.matches', -> { Steps::Matches.new }
    register 'steps.sort', -> { Steps::Sort.new }
    register 'steps.allocate', -> { Steps::Allocate.new }
    register 'steps.notify', -> { Steps::Notify.new }
  end

  module Steps
    class Find
      include Dry::Monads[:result]
      extend  Dry::Initializer
      option :threat, type: Types::Interface(:find), default: -> { AllocateResource::Model::Threat }, reader: :private
      def call(id) = threat.enabled.lock.find(id)
    end

    class Matches
      include Dry::Monads[:result]
      extend  Dry::Initializer

      option :battle, type: Types::Interface(:find), default: -> { AllocateResource::Model::Battle }, reader: :private
      option :heroes,
             type: Types::Interface(:allocatable),
             default: -> { AllocateResource::Model::Hero }, reader: :private
      option :limit, type: Types::Integer, default: -> { 5 }, reader: :private

      def call(threat)
        matches = heroes.allocatable(limit).map do |hero|
          battle.new do |b|
            b.threat = threat
            b.hero = hero
            b.finished_at = FINISHER[threat.rank].call
            b.hero.touch # rubocop:disable Rails/SkipsModelValidations
          end
        end
        return matches if matches.count >= 2

        AppEvents.publish('insufficient.resources', threat:)
        raise StandardError, I18n.t(:insufficient_resources)
      end
    end

    class Sort
      include Dry::Monads[:result]

      # sort_by{...}.reverse is fastest
      def call(matches) = matches.sort_by!(&:score!).reverse!
    end

    class Allocate
      include Dry::Monads[:result]
      extend  Dry::Initializer

      option :tranks,
             type: Types::Instance(ActiveSupport::HashWithIndifferentAccess),
             default: -> { AllocateResource::Model::Threat.ranks },
             reader: :private

      option :hranks,
             type: Types::Instance(ActiveSupport::HashWithIndifferentAccess),
             default: -> { AllocateResource::Model::Hero.ranks },
             reader: :private

      def call(matches_sorted)
        ApplicationRecord.transaction do
          first = matches_sorted.first
          second = matches_sorted.second
          threat = matches_sorted.first.threat

          if tranks[threat.rank] == hranks[first.hero.rank]
            threat.working!
            first.hero.working!
            first.save!
          elsif tranks[threat.rank] == hranks[second.hero.rank]
            threat.working!
            second.hero.working!
            second.save!
          elsif tranks[threat.rank] > hranks[first.hero.rank] && tranks[threat.rank] > hranks[second.hero.rank]
            threat.working!
            first.hero.working!
            second.hero.working!
            first.save!
            second.save!
          end

          threat
        end
      end
    end

    class Notify
      def call(threat)
        AppEvents.publish('resource.allocated', threat:) if threat.working?
        AppEvents.publish('resource.not.allocated', threat:) if threat.enabled?
        threat
      end
    end
  end
end
