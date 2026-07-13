# frozen_string_literal: true

Dry::Validation.load_extensions :monads
Dry::Validation.load_extensions :predicates_as_macros

class ApplicationContract < Dry::Validation::Contract
  config.messages.backend = :i18n

  register_macro(:decimal_fit) do |macro:|
    precision = macro.args[0]
    scale = macro.args[1]
    max_int_digits = precision - scale
    int_part, _ = value.to_s.split('.')
    unless int_part.size <= max_int_digits
      key.failure(I18n.t('errors.decimal_overflow', precision: precision, scale: scale))
    end
  end
end
