# frozen_string_literal: true

module AllocateResource
  class Listener
    def on_resource_not_allocated(e) = Job.perform_later(e[:threat].id)

    def on_insufficient_resources(e)
      REDIS.with { it.set('SNEAKERS_REQUEUE', true) }
      Job.set(wait: 1.minute).perform_later(e[:threat].id)
    end

    def on_resource_allocated(e)
      DeallocateResource::Job.
        set(wait_until: e[:threat].battles.first.finished_at).
        perform_later(e[:threat].id)
      Dashboard::Widgets::AverageScore::Job.perform_later
      Dashboard::Widgets::AverageTimeToMatch::Job.perform_later
      Dashboard::Widgets::BattlesLineup::Job.perform_later
      Dashboard::Widgets::HeroesWorking::Job.perform_later
      Dashboard::Widgets::SuperHero::Job.perform_later
    end
  end
end
