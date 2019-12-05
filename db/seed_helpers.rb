# frozen_string_literal: true

require 'open-uri'

def fetch_new_image
  puts 'Fetching image...'
  open(Faker::Avatar.image)
rescue
  open("https://robohash.org/#{Faker::Lorem.characters(10)}.png?size=300x300&set=set4")
end

def new_image
  {
    io: fetch_new_image,
    filename: "#{Faker::Lorem.characters(8)}_faker_image.jpg"
  }
end
