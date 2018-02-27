require 'aws/xray'

module Aws
  module Xray
    class Railtie < ::Rails::Railtie
      initializer 'aws-xray.set_name' do |app|
        unless Aws::Xray.config.name
          app_name = app.class.parent_name.underscore.gsub(/(\/|_)/, '-')

          if ::Rails.env.production?
            Aws::Xray.config.name = app_name
          else
            Aws::Xray.config.name = "#{app_name}-#{::Rails.env}"
          end
        end
      end

      initializer 'aws-xray.rack_middleware' do |app|
        app.middleware.use Aws::Xray::Rack
      end
    end
  end
end
