# frozen_string_literal: true

class Ws::CreateThreat::Listeners::Dashboard::Widgets::BattlesLineup::Listener
  Job = Ws::CreateThreat::Listeners::Dashboard::Widgets::BattlesLineup::Job

  def on_resource_allocated(_)
    Resque.enqueue_at(3.seconds.from_now, Job) if queue_empty?
  end

  private

  def queue_empty?
    Resque.size(:widget_battles_lineup).zero?
  end
end
