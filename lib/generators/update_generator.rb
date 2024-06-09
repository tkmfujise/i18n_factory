require 'rails/generators'
require 'rails/generators/named_base'

module I18nFactory
  module Generators
    class UpdateGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("templates", __dir__)
      attr_accessor(
        :current_locale,
        :defined_model_name_human,
        :defined_columns,
        :existing_yml,
      )

      def update_i18_file
        I18nFactory::Locale.all.each do |locale|
          self.current_locale = locale
          load_yaml_on(locale)
          if complex?
            template 'plain.yml.erb', path_for_i18n(locale), force: true
          else
            template 'i18n.yml.erb', path_for_i18n(locale), force: true
          end
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

        def clear_instance_variables
          self.defined_columns = {}
          self.defined_model_name_human = nil
          self.existing_yml = nil
        end

        def load_yaml_on(locale)
          clear_instance_variables
          path = path_for_i18n(locale)
          return unless File.exist?(path)

          self.existing_yml = YAML.load_file(path)[locale]
          self.defined_columns = existing_yml['activerecord']['attributes'][model_name]
          self.defined_model_name_human = existing_yml['activerecord']['models'][model_name]
        rescue
        end

        # { foo: { bar: xxx }, piyo: yyy }
        # => ['foo.bar', 'piyo']
        def deep_keys(hash, prefix = nil)
          arr = []
          hash.each do |key, value|
            str = (prefix ? "#{prefix}.#{key}" : key)
            if value.kind_of? Hash
              arr.concat deep_keys(value, str)
            else
              arr << str
            end
          end
          arr
        end

        # activerecord.models と activerecord.attributes 以外も混在している？
        def complex?
          existing_yml.present? && (
            deep_keys(existing_yml).reject{|key|
              key == "activerecord.models.#{model_name}" \
              || key.start_with?("activerecord.attributes.#{model_name}")
          }).any?
        end

        def merged_yml_text
          pretty_yml_text({
            activerecord: {
              models: { model_name => model_name_human },
              attributes: {
                model_name => columns.map{|column, name|
                  { column => name }
                }.reduce(&:merge) || Hash.new
              }
            }
          }.deep_stringify_keys.deep_merge(existing_yml))
        end

        def pretty_yml_text(hash, indent = 2)
          arr = []
          max_length = hash.keys.map(&:length).max 
          hash.each do |key, value|
            case value
            when Hash
              arr.concat [
                ' ' * indent + "#{key}:",
                pretty_yml_text(value, indent + 2)
              ]
            else
              arr << ' ' * indent + \
                str_value(key, value.to_s, indent, max_length)
            end
          end
          arr.join("\n")
        end

        def str_value(key, str, indent, max_length)
          if str.match(/%{.+}/)
            "\"#{str}\""
          elsif str.match(/\R/)
            str.split(/\R/).map{|s|
              ' ' * (indent + 2) + s
            }
          else
            str.blank? ? '""' : str
          end.try{|value|
            if value.kind_of?(Array)
              "#{key}: |-\n" + value.join("\n")
            else
              "#{key}:".ljust(max_length + 2) + value
            end
          }
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

