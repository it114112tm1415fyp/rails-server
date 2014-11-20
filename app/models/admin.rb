class Admin < ActiveRecord::Base
	validates_format_of(:password, with: /[\da-f]{32}/)
end
