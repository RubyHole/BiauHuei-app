# frozen_string_literal: true

module BiauHuei
  module Form
    def self.validation_errors(validation)
      validation.errors.map { |k, v| [k, v].join(' ') }.join('; ')
    end

    def self.message_values(validation)
      validation.messages.values.join('; ')
    end
  end
end
