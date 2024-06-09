module I18nFactory
  class Locale
    def self.all
      if I18nFactory.config.locales.any?
        I18nFactory.config.locales.map(&:to_s)
      else
        [default]
      end
    end

    def self.default
      I18n.locale.to_s
    end
  end
end
