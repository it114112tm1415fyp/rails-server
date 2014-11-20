class ShopAddress < ActiveRecord::Base
	has_many(:check_logs, as: :location)
	has_many(:goods, as: :location)
end
