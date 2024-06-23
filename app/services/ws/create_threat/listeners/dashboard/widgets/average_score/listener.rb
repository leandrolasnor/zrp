# frozen_string_literal: true

class Ws::CreateThreat::Listeners::Dashboard::Widgets::AverageScore::Listener
  Job = Ws::CreateThreat::Listeners::Dashboard::Widgets::AverageScore::Job

  def on_resource_allocated(_)
    Resque.enqueue_at(1.minute.from_now, Job) if queue_empty?
  end

  private

  def queue_empty?
    Resque.size(:widget_average_score).zero?
  end
end
