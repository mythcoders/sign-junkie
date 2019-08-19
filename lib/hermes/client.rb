# frozen_string_literal: true

# module Hermes
#   class Client
#     # use the block to set module privided instance variables:
#     # ```ruby
#     # Client.new('mark') do |client|
#     #   client.contacts_path = '/'
#     #   client.contacts_host = 'http://contacts-api.dev'
#     # end
#     # ```
#     #
#     # Defaults are to proudction to make it easy for external gem consumers.
#     def initialize(username, password=nil)
#       @username = username
#       @password = password
#       yield(self) if block_given?
#     end

#     attr_writer :default_host
#     def default_host
#       @default_host ||= "https://pg-update.review.hermes.mythcoders.io"
#     end

#     def send_message(message)

#     end
#   end
# end
