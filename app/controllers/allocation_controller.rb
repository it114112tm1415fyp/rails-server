class AllocationController < DotNetApplicationController
	def get_goods_details
		params_require(:rfid)
		options = {
				only: [
						:flammable,
						:fragile,
						:created_at,
						:weight,
						:order_id,
						:string_id,
						:rfid_tag
				],
				include: [
						{
								next_stop: {
										only: [
												:id,
												:region_id
										],
										method: :type,
										merge_type: :replace
								}
						},
						{
								departure: {
										collect: :long_name
								}
						},
						{
								destination: {
										collect: :long_name
								}
						},
				],
				merge_type: :replace,
				rename: {
						string_id: :id
				}
		}
		response_simple_success(Goods.find_by_rfid_tag!(params[:rfid]).as_json(options))
	end
end
