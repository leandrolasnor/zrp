# frozen_string_literal: true

module Rpc::AlertReceives::UN
  class Listeners::AllocateResource::Job
    include Dry.Types()
    extend Dry::Initializer

    option :transaction, type: Interface(:call), default: -> { AllocateResource::Transaction.new }, reader: :private
    option :allocate_resource_listener,
           type: Instance(Object),
           default: -> { Listeners::AllocateResource::Listener.new }, reader: :private
    option :deallocate_resource_listener,
           type: Instance(Object),
           default: -> { Listeners::DeallocateResource::Listener.new }, reader: :private
    option :widget_heroes_working_listener,
           type: Instance(Object),
           default: -> { Listeners::Dashboard::Widgets::HeroesWorking::Listener.new }, reader: :private
    option :widget_battles_lineup_listener,
           type: Instance(Object),
           default: -> { Listeners::Dashboard::Widgets::BattlesLineup::Listener.new }, reader: :private
    option :widget_average_score_listener,
           type: Instance(Object),
           default: -> { Listeners::Dashboard::Widgets::AverageScore::Listener.new }, reader: :private
    option :widget_average_time_to_match_listener,
           type: Instance(Object),
           default: -> { Listeners::Dashboard::Widgets::AverageTimeToMatch::Listener.new }, reader: :private
    option :widget_super_hero_listener,
           type: Instance(Object),
           default: -> { Listeners::Dashboard::Widgets::SuperHero::Listener.new }, reader: :private

    def call(threat_id)
      transaction.operations[:notify].subscribe(allocate_resource_listener)
      transaction.operations[:notify].subscribe(deallocate_resource_listener)
      transaction.operations[:notify].subscribe(widget_heroes_working_listener)
      transaction.operations[:notify].subscribe(widget_battles_lineup_listener)
      transaction.operations[:notify].subscribe(widget_average_score_listener)
      transaction.operations[:notify].subscribe(widget_average_time_to_match_listener)
      transaction.operations[:notify].subscribe(widget_super_hero_listener)

      ApplicationRecord.connection_pool.with_connection do
        transaction.call(threat_id) do
          it.failure :find do |f|
            Rails.logger.error(f)
          end

          it.failure :matches do |f|
            Rails.logger.error(f.message)
            time = scarce?(f) ? Resque.size(:matches) * 5 : 5
            Resque.enqueue_at(time.seconds.from_now, self.class, threat_id)
            REDIS.with { it.set('SNEAKERS_REQUEUE', scarce?(f)) }
          end

          it.failure :allocate do |f|
            Rails.logger.error(f.message)
            Resque.enqueue_at(5.seconds.from_now, self.class, threat_id)
          end

          it.failure do |f|
            Rails.logger.error(f.message)
          end

          it.success {}
        end
      end
    end

    @queue = :matches
    def self.perform(threat_id) = new.call(threat_id)
    include Resque::Plugins::UniqueByArity.new(
      arity_for_uniqueness: 1,
      unique_at_runtime: true,
      unique_in_queue: true
    )

    private

    def scarce?(f)
      I18n.t(:insufficient_resources) == f.message
    end
  end
end
