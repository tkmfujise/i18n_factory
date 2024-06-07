require 'rails/generators'
require 'rails/generators/named_base'

module I18nFactory
  module Generators
    class UpdateAllGenerator < Rails::Generators::Base
      def update_all_i18n_files
        all_model_names.each do |name|
          begin
            if name.constantize.ancestors.include? ActiveRecord::Base
              generate 'i18n_factory:update', name
            end
          end
        end
      end

      private
        def all_model_names
          model_names = Dir["#{Rails.root.join('app/models')}/*.rb"].map{|path|
              path.match(/app\/models\/(.*)\.rb/); $1
            }.map(&:camelize)

          model_names.reject{|model_name|
            model_name == 'ApplicationRecord'
          }
        end
    end
  end
end

