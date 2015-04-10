class TimeController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	before_action(:check_customer_login, except: :get_receive_time_segments)
	def get_order_receive_free_time
		params_require(:order_id)
		free_time = Order.find(params[:order_id]).meaningful_free_times
		free_time = ReceiveTimeFormatter.format(free_time)
		response_success(free_time)
	end
	def get_receive_time_segments
		response_success(ReceiveTimeSegment.enabled)
	end
end
