require(File.expand_path('../boot', __FILE__))

require('rails/all')

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require(File.expand_path('../config', __FILE__))
require(File.expand_path('../../boot/loader', __FILE__))

module FYP
	class Application < Rails::Application
		Date.beginning_of_week = :sunday
		config.time_zone = 'Hong Kong'
		config.after_initialize do
			ExtensionLoader.load
			RailsServer.on_standby do
				Cron.start
				ConveyorConnector.start
				TaskManager.start
			end
		end
	end
end
