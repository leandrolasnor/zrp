# frozen_string_literal: true

module Rpc::AlertReceives::UN::Listeners::Sneakers::Requeue
  class Listener
    def on_heroes_working(e)
      Resque.enqueue(Job, e[:heroes_working_metrics])
    end
  end
end
