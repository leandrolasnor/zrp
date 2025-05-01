# frozen_string_literal: true

module AllocateResource
  class Listener
    def on_resource_not_allocated(e) = Resque.enqueue(Job, e[:threat].id)

    def on_insufficient_resources(e)
      REDIS.with { it.set('SNEAKERS_REQUEUE', true) }
      Resque.enqueue_at(1.minute, Job, e[:threat].id)
    end

    def on_resource_allocated(e)
      Resque.enqueue_at(e[:threat].battles.first.finished_at, DeallocateResource::Job, e[:threat].id)
      Resque.enqueue(Dashboard::Widgets::AverageScore::Job)
      Resque.enqueue(Dashboard::Widgets::AverageTimeToMatch::Job)
      Resque.enqueue(Dashboard::Widgets::BattlesLineup::Job)
      Resque.enqueue(Dashboard::Widgets::HeroesWorking::Job)
      Resque.enqueue(Dashboard::Widgets::SuperHero::Job)
    end
  end
end
