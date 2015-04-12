class GoodsRouter
	# @param [Goods] goods
	def initialize(goods)
		# @type [Goods] @goods
		@goods = goods
		# @type [Car, Shop, SpecifyAddress, Store] @location
		order = goods.order
		# @type [Shop, SpecifyAddress] @departure
		@departure = order.departure
		# @type [Shop, SpecifyAddress] @destination
		@destination = order.destination
	end
	def route
		@route ||= [@departure, @departure.region.store, @destination.region.store, @destination]
	end
	def next_stop
		return nil if @goods.location == @destination
		@route[@route.find_index(@goods.location) + 1] || @destination.region.store
	end
end
