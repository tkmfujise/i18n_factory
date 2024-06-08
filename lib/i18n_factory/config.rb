module I18nFactory
  CONFIGURATIONS = %i(
    locales
    ignore_columns
  ) 

  def self.config
    @_config ||= Struct.new(*CONFIGURATIONS).new
  end

  def self.configure(&block)
    yield config
  end

  # default values
  config.locales = []
  config.ignore_columns = %i(id created_at updated_at)
end
