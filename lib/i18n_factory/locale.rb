module I18nFactory
  class Locale
    def self.all
      [default] # TODO load from config
    end

    def self.default
      I18n.locale.to_s
    end
  end
end
