require 'rails/generators'
require 'rails/generators/named_base'

module I18nFactory
  module Generators
    class UpdateGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)
      attr_accessor :current_locale, :defined_model_name_human, :defined_columns

      def update_i18_file
        I18nFactory::Locale.all.each do |locale|
          self.current_locale = locale
          load_yaml_on(locale)
          template 'i18n.yml.erb', path_for_i18n(locale), force: true
        end
      end

      private
        def path_for_i18n(locale)
          File.join("config/locales/#{model_name}", "#{locale}.yml")
        end

        def model_name
          name.underscore
        end

        def model_name_human
          defined_model_name_human || name.camelize
        end

        def const
          name.camelize.constantize
        end

        def load_yaml_on(locale)
          self.defined_columns = {}
          self.defined_model_name_human = nil
          path = path_for_i18n(locale)
          return unless File.exist?(path)

          yml = YAML.load_file(path)[locale]
          self.defined_columns = yml['activerecord']['attributes'][model_name]
          self.defined_model_name_human = yml['activerecord']['models'][model_name]
        rescue
        end

        def column_names
          const.column_names - I18nFactory.config.ignore_columns.map(&:to_s)
        end

        def columns
          column_names.map{|c|
            { c => c.camelize }
          }.reduce(&:merge).merge(defined_columns)
        end
    end
  end
end

