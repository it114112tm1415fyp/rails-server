class Good < ActiveRecord::Base
	has_many(:check_logs)
end
