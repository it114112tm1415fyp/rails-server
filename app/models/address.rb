class Address < ActiveRecord::Base
	belongs_to(:address_type)
	has_many(:check_logs, foreign_key: :location_id)
	has_many(:conveyors, foreign_key: :location_id)
	has_many(:goods, foreign_key: :location_id)
	has_many(:users, through: :address_user_ships)
	validates_absence_of(:size, unless: proc { address_type.has_size if address_type })
	validates_numericality_of(:size, greater_than: 0, if: proc { address_type.has_size if address_type })
	validates_uniqueness_of(:address_type_id, if: proc { address_type.is_unique if address_type })
end
