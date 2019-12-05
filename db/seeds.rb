# frozen_string_literal: true

require_relative 'seed_helpers'

puts 'Running required seeds...'
Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each do |seed|
  load seed
end

return if Rails.env.production? || Rails.env.test?

puts 'Running optional seeds...'
Dir[File.join(Rails.root, 'db', 'seeds', 'optional', '*.rb')].sort.each do |seed|
  load seed
end
