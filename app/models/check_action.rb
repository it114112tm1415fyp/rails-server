class CheckAction < ActiveRecord::Base
	has_many(:check_logs)
end
