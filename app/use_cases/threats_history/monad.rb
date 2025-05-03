# frozen_string_literal: true

class ThreatsHistory::Monad
  include Dry::Monads[:try]

  extend  Dry::Initializer

  option :page, type: Types::Coercible::Integer, default: -> { 1 }, reader: :private
  option :per_page, type: Types::Coercible::Integer, default: -> { 25 }, reader: :private
  option :order, type: Types::Coercible::String, default: -> { 'battles.finished_at desc' }, reader: :private
  option :threat, default: -> { ThreatsHistory::Model::Threat }, reader: :private,
                  type: Types::Interface(:fresh, :disabled, :includes, :page, :order)

  def call = Try { threat.fresh.disabled.includes([:battles, :heroes]).page(page).per(per_page).order(order) }
end
