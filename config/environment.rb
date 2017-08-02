# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Initialize Carrierwave
require 'carrierwave/orm/activerecord'
