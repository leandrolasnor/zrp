# frozen_string_literal: true

module Update::Hero
  module Steps
    class Find
      extend Dry::Initializer

      option :model, type: Types::Interface(:find, :lock), default: -> { Models::Hero }, reader: :private

      def call(params) = params.to_h.merge(record: model.lock.find(params[:id]))
    end
  end
end
