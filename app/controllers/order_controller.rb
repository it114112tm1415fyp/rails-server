class OrderController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	include(StaffMobileApplicationModule)
	before_action(:check_customer_login, only: [:edit, :get_receive_orders, :get_send_orders, :make])
	before_action(:check_staff_login, except: [:edit, :get_receive_orders, :get_send_orders, :make])
	before_action(:check_order, except: [:get_receive_orders, :get_send_orders, :make])
	def cancel
		@order.cancel(@staff)
	end
	def confirm
		params_require(:sender_sign)
		@order.confirm(params[:sender_sign])
	end
	def contact
		@order.contact
	end
	def edit
		@order.edit(params[:receiver], params[:goods_number], params[:departure_id], params[:departure_type], params[:destination_id], params[:destination_type], @staff)
	end
	def get_receive_orders
		json_response_success({receive_order: @customer.get_receive_orders})
	end
	def get_send_orders
		json_response_success({send_order: @customer.get_send_orders})
	end
	def make
		params_require(:receiver, :goods_number, :departure_id, :departure_type, :destination_id, :destination_type)
		json_response_success(Order.make(@customer, params[:receiver], params[:goods_number], params[:departure_id], params[:departure_type], params[:destination_id], params[:destination_type], params[:time]))
	end
	private
	def check_order
		params_require(:order_id)
		@order = Order.find(params[:order_id])
		error('cannot edit order information after confirm') unless @order.can_edit
	end
end
