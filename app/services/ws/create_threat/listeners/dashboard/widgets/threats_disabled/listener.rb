# frozen_string_literal: true

class Ws::CreateThreat::Listeners::Dashboard::Widgets::ThreatsDisabled::Listener
  Job = Ws::CreateThreat::Listeners::Dashboard::Widgets::ThreatsDisabled::Job

  def on_resource_deallocated(_)
    Resque.enqueue_at(3.seconds.from_now, Job) if queue_empty?
  end

  def on_threat_created(_)
    Resque.enqueue_at(3.seconds.from_now, Job) if queue_empty?
  end

  private

  def queue_empty?
    Resque.size(:widget_threats_disabled).zero?
  end
end
