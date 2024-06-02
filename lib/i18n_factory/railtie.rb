require 'rails/railtie'

module ActiveModel
  class Railtie < Rails::Railtie
    generators do |app|
      Rails::Generators.configure! app.config.generators
      require_relative '../generators/model_generator'
    end
  end
end


# module I18nFactory
#   class Railtie < Rails::Railtie
#   end
# end
