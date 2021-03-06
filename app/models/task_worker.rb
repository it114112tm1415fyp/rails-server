class TaskWorker < ActiveRecord::Base
	belongs_to(:check_action)
	belongs_to(:staff)
	belongs_to(:task, polymorphic: true)
	has_many(:check_logs)
	# @param [Hash] options
	# @return [Hash]
	def as_json(options={})
		goods_task_ships_options = {
				goods_task_ships: {
						skip: :if_not_exist,
						only: [],
						collect: {
								goods: {
										only: [
												:string_id,
												:shelf_id
										],
										merge_type: :replace
								}
						},
						method: {
								has_check_log: {
										parameter: [check_action],
								}
						},
						rename: {
								string_id: :goods_id,
								has_check_log: :completed
						},
						merge_type: :replace
				}
		}
		super(
				Option.new(
						options,
						only: :id,
						collect: {
								task: {
										except: :completed,
										method: [
												:task_code,
												{
														can_do: {
																parameter: [check_action]
														}
												},
												goods_task_ships_options,
												{
														order_task_ships: {
																skip: :if_not_exist,
																except: :completed,
																method: [
																		goods_task_ships_options,
																		{
																				partly_completed: {
																						parameter: [check_action]
																				}
																		}
																],
																rename: {
																		goods_task_ships: :goods_in_task,
																		partly_completed: :completed
																},
																remove: :goods
														}
												},
												{
														partly_completed: {
																skip: :if_not_exist,
																parameter: [check_action]
														}
												}
										]
								}
						},
						include: :check_action,
						rename: {
								goods_task_ships: :goods_in_task,
								order_task_ships: :order_in_task,
								partly_completed: :completed
						},
						remove: :goods_ids
				)
		)
	end
	# @param [String] goods_id
	# @param [Hash] addition
	# @return [Meaningless]
	def do_task(goods_id, addition)
		transaction do
			goods = Goods.find_by_string_id(goods_id)
			check_action.edit_goods(goods, self, addition)
			if task.is_a?(ServeTask)
				task_goods = task.goods_serve_task_ships.find_by_goods_id(goods.id) || GoodsServeTaskShip.create!(goods: goods, serve_task: task)
			else
				task_goods = task.goods_task_ships.find_by_goods_id(goods.id)
			end
			CheckLog.create!(task_worker: self, task_goods: task_goods)
			task.check_completed unless task.is_a?(ServeTask)
		end
	end
	# @param [Integer] order_id
	# @param [String] customer_free
	# @return [Meaningless]
	def contact(order_id, customer_free)
		transaction do
			raise(TypeError) unless task.is_a?(VisitTask)
			raise(ArgumentError) unless ['true', 'false'].include?(customer_free)
			error('this order has been contacted by other staff') if task.contacted || order_id.to_i != task.next_order_for_content.order_id
			order = Order.find(order_id)
			order_queue = order.queue
			raise(ArgumentError) unless order_queue.visit_task == task
			if customer_free == 'true'
				task.add_order(order)
				order.contact
			else
				order_queue.again
			end
			order_queue.destroy!
			task.check_contacted
		end
	end
end
