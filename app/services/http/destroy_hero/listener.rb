# frozen_string_literal: true

module Http::DestroyHero
  module Listener
    module_function

    def on_step_succeeded(e)
      destroyed = e.payload[:args].first
      RemoveFromIndex::Job.perform_later(id: destroyed.id, model: destroyed.class.name)
    end
  end
end
