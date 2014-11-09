# Load the Rails application.
require File.expand_path('../application', __FILE__)

ENV['SECRET_KEY_BASE'] = Random.rand(2 ** 128).to_s(16)

# Initialize the Rails application.
Rails.application.initialize!
