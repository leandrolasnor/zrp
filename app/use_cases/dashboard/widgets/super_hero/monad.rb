# frozen_string_literal: true

class Dashboard::Widgets::SuperHero::Monad
  include Dry::Monads[:try]
  extend Dry::Initializer

  option :model, type: Types::Interface(:ms_raw_search), default: -> { Dashboard::Model::Hero }, reader: :private

  def call
    Try do
      name, rank = model.includes(:battles)
        .where('battles.finished_at': 20.minutes.ago...::Time.zone.now)
        .group(:name, :rank).sum(:score).max_by(&:second)&.first
      { name: name, rank: rank }
    end
  end
end
