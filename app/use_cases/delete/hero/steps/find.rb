# frozen_string_literal: true

module Delete::Hero
  module Steps
    class Find
      extend Dry::Initializer

      option :model, type: Types::Interface(:find), default: -> { Models::Hero }, reader: :private

      def call(id:, **_) = model.lock.find(id)
    end
  end
end
