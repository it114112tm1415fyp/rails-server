class ConstantController < MobileApplicationController
	def get
		params_require(:key)
		value = Constant.find_by_key(params[:key])
		response_success(value && value.casted_value)
	end
end
