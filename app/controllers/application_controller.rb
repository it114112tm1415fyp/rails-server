class ApplicationController < ActionController::Base
	private
	def only_available_at_development
		raise(NotInDevelopmentModeError) unless ENV['rails_env'] == 'development'
	end
	def params_require(*keys)
		keys.each { |x| params.require(x) }
	end
	def params_exist(*keys)
		keys.all? { |x| params.key?(x) }
	end
end
