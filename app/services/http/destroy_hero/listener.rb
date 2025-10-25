# frozen_string_literal: true

module Http::DestroyHero
  module Listener
    module_function

    def on_step_succeeded(e) = RemoveFromIndex::Job.perform_later(id: e.payload[:id], model: Delete::Hero::Models::Hero)
  end
end
