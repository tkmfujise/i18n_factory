# frozen_string_literal: true

require_relative "i18n_factory/version"
require_relative "i18n_factory/locale"
require_relative "i18n_factory/railtie"
require_relative 'generators/update_generator'
require_relative 'generators/update_all_generator'

module I18nFactory
  class Error < StandardError; end
  # Your code goes here...
end
