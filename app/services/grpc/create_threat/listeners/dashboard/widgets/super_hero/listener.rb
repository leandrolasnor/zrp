# frozen_string_literal: true

class Grpc::CreateThreat::Listeners::Dashboard::Widgets::SuperHero::Listener
  Job = Grpc::CreateThreat::Listeners::Dashboard::Widgets::SuperHero::Job

  def on_resource_allocated(_)
    Resque.enqueue_at(1.minute.from_now, Job) if queue_empty?
  end

  private

  def queue_empty?
    Resque.size(:widget_super_hero).zero?
  end
end
