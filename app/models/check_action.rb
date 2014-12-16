class CheckAction < ActiveRecord::Base
	has_many(:check_logs)
	has_many(:goods)
end
