# frozen_string_literal: true

module CRUD::Create::Hero
  class Steps::Create
    include Dry::Monads[:result]
    include Dry::Events::Publisher[:hero_created]
    include Dry.Types()
    extend  Dry::Initializer

    register_event 'hero.created'

    option :hero, type: Interface(:create), default: -> { Model::Hero }, reader: :private

    def call(params)
      created = hero.create do
        _1.name = params[:name]
        _1.rank = params[:rank]
        _1.lat = params[:lat]
        _1.lng = params[:lng]
      end
      publish('hero.created', hero: created)
      created
    end
  end
end
