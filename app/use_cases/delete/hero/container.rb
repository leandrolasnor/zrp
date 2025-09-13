# frozen_string_literal: true

module Delete
  module Hero
    class Container
      extend Dry::Container::Mixin

      register 'steps.find', -> { Steps::Find.new }
      register 'steps.destroy', -> { Steps::Destroy.new }
    end

    module Steps
      class Find
        extend Dry::Initializer

        option :model, type: Types::Interface(:find), default: -> { Models::Hero }, reader: :private

        def call(id:, **_) = model.enabled.lock('FOR UPDATE SKIP LOCKED').find_by(id:)
      end

      class Destroy
        def call(hero)
          raise ActiveRecord::RecordNotDestroyed.new(I18n.t(:cannot_destroy_hero)) if hero.blank?

          hero.destroy!
        end
      end
    end
  end
end
