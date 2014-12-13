class GoodController < MobileApplicationController
	include(StaffMobileApplicationModule)
	before_action(:check_staff_login)
	def inspect
		params_require(:good_id, :store_id)
		Good.inspect(params[:good_id], params[:store_id], @staff)
	end
	def warehouse
		params_require(:good_id, :location_id, :location_type)
		Good.warehouse(params[:good_id], params[:location_id], params[:location_type], @staff)
	end
	def leave
		params_require(:good_id, :location_id, :location_type)
		Good.leave(params[:good_id], params[:location_id], params[:location_type], @staff)
	end
	def load
		params_require(:good_id, :car_id)
		Good.load(params[:good_id], params[:car_id], @staff)
	end
	def unload
		params_require(:good_id, :car_id)
		Good.unload(params[:good_id], params[:car_id], @staff)
	end
end
