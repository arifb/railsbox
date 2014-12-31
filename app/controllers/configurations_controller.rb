class ConfigurationsController < ApplicationController
  def create
    configurator = Configurator.from_params(params)
    builder = ConfigurationBuilder.new(configurator)
    zip_path = builder.build
    send_file zip_path, filename: configurator.file_name
  end
end
