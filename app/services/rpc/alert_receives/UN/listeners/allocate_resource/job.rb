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
      transaction.operations[:allocate].subscribe(allocate_resource_listener)
      transaction.operations[:allocate].subscribe(deallocate_resource_listener)
      transaction.operations[:allocate].subscribe(widget_heroes_working_listener)
      transaction.operations[:allocate].subscribe(widget_battles_lineup_listener)
      transaction.operations[:allocate].subscribe(widget_average_score_listener)
      transaction.operations[:allocate].subscribe(widget_average_time_to_match_listener)
      transaction.operations[:allocate].subscribe(widget_super_hero_listener)

      ApplicationRecord.connection_pool.with_connection do
        transaction.call(threat_id) do
          _1.failure :find do |f|
            Rails.logger.error(f)
          end

          _1.failure :matches do |f|
            Rails.logger.error(f.message)
            Resque.enqueue(self.class, threat_id)
          end

          _1.failure :allocate do |f|
            Rails.logger.error(f.message)
            Resque.enqueue(self.class, threat_id)
          end

          _1.failure do |f|
            Rails.logger.error(f.message)
          end

          _1.success {}
        end
      end
    end

    @queue = :matches
    def self.perform(threat_id) = new.call(threat_id)
    include Resque::Plugins::UniqueByArity.new(
      arity_for_uniqueness: 1,
      unique_in_queue: true,
      unique_at_runtime: true
    )
  end
end
