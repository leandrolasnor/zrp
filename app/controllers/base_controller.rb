# frozen_string_literal: true

class BaseController < ApplicationController
  class_attribute :param_schemas, default: {}

  class << self
    def permit_params(action, schema)
      param_schemas[action.to_sym] = schema
    end
  end

  private

  def params
    schema = self.class.param_schemas[action_name.to_sym]
    return super unless schema

    if schema.key?(:required)
      super.required(schema[:required]).permit(*schema[:permit])
    elsif schema.key?(:expect)
      super.expect(schema[:expect])
    else
      super.permit(*schema[:permit])
    end
  end
end
