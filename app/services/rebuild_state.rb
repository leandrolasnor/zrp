# frozen_string_literal: true

require_relative 'rebuild_state/service'

module RebuildState
  def self.call = Service.call
end
