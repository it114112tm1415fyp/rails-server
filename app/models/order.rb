class Order < ActiveRecord::Base
	has_one(:sender, class_name: 'User', foreign_key: :sender_id)
	has_one(:receiver, class_name: 'User', foreign_key: :receiver_id)
	has_one(:staff, class_name: 'User', foreign_key: :staff_id)
	has_one(:payer, class_name: 'User', foreign_key: :payer_id)
end
