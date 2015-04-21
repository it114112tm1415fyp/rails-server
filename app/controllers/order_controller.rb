class OrderController < MobileApplicationController
	include(CustomerMobileApplicationModule)
	include(StaffMobileApplicationModule)
	before_action(:check_customer_login, only: [:cancel, :edit, :get_details, :get_receive_orders, :get_send_orders, :make])
	before_action(:check_staff_login, except: [:cancel, :edit, :get_details, :get_receive_orders, :get_send_orders, :make])
	before_action(:find_order, except: [:get_details, :get_receive_orders, :get_send_orders, :get_list, :make])
	def cancel
		@order.cancel(@staff)
	end
	def confirm
		params_require(:task_id, :sign)
		@order.confirm(params[:task_id], params[:sign])
	end
	def contact
		@order.contact
	end
	def edit
		@order.edit(params[:receiver], params[:goods_number], params[:departure_id], params[:departure_type], params[:destination_id], params[:destination_type], params[:time], @staff)
	end
	def get_details
		response_success(Order.find(params[:order_id]))
	end
	def get_receive_orders
		response_success({receive_order: @customer.receive_orders})
	end
	def get_send_orders
		response_success({send_order: @customer.send_orders})
	end
	def get_list
		response_success(Order.all)
	end
	def get_price
		response_success(@order.price)
	end
	def make
		params_require(:receiver, :goods_number, :departure_id, :departure_type, :destination_id, :destination_type)
		response_success(id: Order.make(@customer, params[:receiver], params[:goods_number], params[:departure_id], params[:departure_type], params[:destination_id], params[:destination_type], params[:time]).id)
	end
	private
	def find_order
		params_require(:order_id)
		@order = Order.find(params[:order_id])
	end
end
