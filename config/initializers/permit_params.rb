# frozen_string_literal: true

PermitParams.configure do |config|
  # Schema applied to actions that do not declare their own through
  # `permit_params`. Leave it as nil (the default) to keep the framework
  # default for those actions.
  #
  # config.default_schema = { permit: [:page, :per_page] }

  # Raise PermitParams::MissingSchemaError when an action has neither its own
  # schema nor a default_schema. Handy to force every action to be explicit.
  #
  # config.raise_on_missing_schema = false
end
