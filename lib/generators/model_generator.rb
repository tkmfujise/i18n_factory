require 'rails/generators'
require 'rails/generators/named_base'
require 'rails/generators/rails/model/model_generator'

Rails::Generators::ModelGenerator.hook_for(
  :i18n_factory,
  default: true, type: :boolean
) do |model, i18n_factory|
  model.invoke i18n_factory, [
    model.name, model.attributes.map(&:name)
  ]
end

module I18nFactory
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)
      argument :attributes, type: :array, default: []
      attr_accessor :current_locale

      def generate
        locales.each do |locale|
          self.current_locale = locale
          template 'i18n.yml.erb', path_for_i18n(locale)
        end
      end

      private
        def path_for_i18n(locale)
          File.join("config/locales/#{model_name}", "#{locale}.yml")
        end

        def model_name
          name.underscore
        end

        def locales
          [default_locale]
        end

        def default_locale
          I18n.locale.to_s
        end
    end
  end
end
