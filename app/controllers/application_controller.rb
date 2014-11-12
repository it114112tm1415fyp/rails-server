class ApplicationController < ActionController::Base
	private
	def params_require(*keys)
		keys.each { |x| params.require(x) }
	end
end
