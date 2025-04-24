# frozen_string_literal: true

module Create::Hero
  module Steps
    class Persist
      extend Dry::Initializer

      option :model, type: Types::Interface(:create), default: -> { Models::Hero }, reader: :private

      def call(params)
        model.create do
          it.name = params[:name]
          it.rank = params[:rank]
          it.lat = params[:lat]
          it.lng = params[:lng]
        end
      end
    end
  end
end
