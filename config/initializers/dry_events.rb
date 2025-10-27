# frozen_string_literal: true

Rails.configuration.to_prepare do
  Dry::Events::Publisher.registry.clear
end

class AppEvents
  include Dry::Events::Publisher[:app]
  include Singleton

  def self.publish(...) = self.instance.publish(...)
  def self.subscribe(...) = self.instance.subscribe(...)

  EVENTS = [
    'insufficient.resources', 'resource.allocated', 'resource.not.allocated',
    'resource.deallocated', 'threat.created', 'metrics.fetched',
    'hero.removed_from_index'
  ].freeze

  EVENTS.each { register_event it }
end

AppEvents.subscribe('threat.created') do
  AllocateResource::Job.perform_later(it[:threat].id)
  Dashboard::Widgets::ThreatsDisabled::Job.perform_later
  Dashboard::Widgets::ThreatsDistribution::Job.perform_later
  RES.pub UN::AlertReceived, "#{it[:threat].class.name.demodulize}##{it[:threat].id}", it[:threat].payload
end

AppEvents.subscribe('insufficient.resources') do
  REDIS.with { |redis| redis.set('SNEAKERS_REQUEUE', true, ex: 60) }
  AllocateResource::Job.set(wait: 1.minute).perform_later(it[:threat].id)
  Dashboard::Widgets::HeroesDistribution::Job.perform_later
  RES.pub InsufficientResource, "#{it[:threat].class.name.demodulize}##{it[:threat].id}"
end

AppEvents.subscribe('resource.deallocated') do
  Dashboard::Widgets::HeroesWorking::Job.perform_later
  Dashboard::Widgets::ThreatsDisabled::Job.perform_later
  RES.pub ResourceDeallocated, "#{it[:threat].class.name.demodulize}##{it[:threat].id}", it[:threat].heroes.to_json
end

AppEvents.subscribe('resource.allocated') do
  DeallocateResource::Job.
    set(wait_until: it[:threat].battles.first.finished_at).
    perform_later(it[:threat].id)
  Dashboard::Widgets::AverageScore::Job.perform_later
  Dashboard::Widgets::AverageTimeToMatch::Job.perform_later
  Dashboard::Widgets::BattlesLineup::Job.perform_later
  Dashboard::Widgets::HeroesWorking::Job.perform_later
  Dashboard::Widgets::SuperHero::Job.perform_later
  RES.pub ResourceAllocated, "#{it[:threat].class.name.demodulize}##{it[:threat].id}", it[:threat].heroes.to_json
end

AppEvents.subscribe('resource.not.allocated') do
  AllocateResource::Job.perform_later(it[:threat].id)
  Dashboard::Widgets::HeroesDistribution::Job.perform_later
  RES.pub ResourceNotAllocated, "#{it[:threat].class.name.demodulize}##{it[:threat].id}", it[:matches_sorted].map(&:hero).to_json
end

AppEvents.subscribe('hero.removed_from_index') do
  Dashboard::Widgets::HeroesWorking::Job.perform_later
  Dashboard::Widgets::HeroesDistribution::Job.perform_later
  RES.pub HeroRemovedFromIndex, "#{it[:model].demodulize}##{it[:id]}", it[:document].to_json
end
