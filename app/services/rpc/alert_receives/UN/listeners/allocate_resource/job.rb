# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners
  class AllocateResource::Job < ApplicationJob
    extend Dry::Initializer

    option :transaction, type: Types::Interface(:call), default: -> {
      AllocateResource::Transaction.new
    }, reader: :private
    option :allocate_resource_listener,
           type: Types::Instance(Object),
           default: -> { AllocateResource::Listener.new }, reader: :private
    option :deallocate_resource_listener,
           type: Types::Instance(Object),
           default: -> { DeallocateResource::Listener.new }, reader: :private
    option :widget_heroes_working_listener,
           type: Types::Instance(Object),
           default: -> { Dashboard::Widgets::HeroesWorking::Listener.new }, reader: :private
    option :widget_battles_lineup_listener,
           type: Types::Instance(Object),
           default: -> { Dashboard::Widgets::BattlesLineup::Listener.new }, reader: :private
    option :widget_average_score_listener,
           type: Types::Instance(Object),
           default: -> { Dashboard::Widgets::AverageScore::Listener.new }, reader: :private
    option :widget_average_time_to_match_listener,
           type: Types::Instance(Object),
           default: -> { Dashboard::Widgets::AverageTimeToMatch::Listener.new }, reader: :private
    option :widget_super_hero_listener,
           type: Types::Instance(Object),
           default: -> { Dashboard::Widgets::SuperHero::Listener.new }, reader: :private

    queue_as :critical
    def perform(threat_id)
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
            self.class.set(wait: 1.minute).perform_later(threat_id)
            REDIS.with { it.set('SNEAKERS_REQUEUE', scarce?(f)) }
          end

          it.failure :allocate do |f|
            Rails.logger.error(f.message)
            self.class.set(wait: 5.seconds).perform_later(threat_id)
          end

          it.failure do |f|
            Rails.logger.error(f.message)
          end

          it.success {}
        end
      end
    end

    private

    def scarce?(f) = I18n.t(:insufficient_resources) == f.message
  end
end
