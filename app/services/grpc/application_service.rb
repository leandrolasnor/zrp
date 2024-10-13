# frozen_string_literal: true

class Grpc::ApplicationService
  private_class_method :new
  include Gruf::Errors::Helpers
  include Dry.Types()
  extend Dry::Initializer

  param :request, type: Instance(Gruf::Controllers::Request), reader: :private

  def self.call(request:)
    new(request).()
  end

  private

  attr_accessor :res

  def error_handler
    e = res.exception
    set_debug_info(e.message, e.backtrace[0..4])
    fail!(:internal, :internal, "ERROR: #{e.message}")
  end
end
