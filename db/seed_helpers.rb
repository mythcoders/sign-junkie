# frozen_string_literal: true

require "open-uri"

def random_image
  puts "Fetching backup image"
  open("https://robohash.org/#{Faker::Lorem.characters(number: 12)}.png?set=set4")
rescue
  puts "Fatal error!"
end

# standard:disable Security/Open
def fetch_new_image
  puts "Fetching image"
  open(Faker::Avatar.image)
rescue OpenURI::HTTPError
  puts "HTTP error fetching image"
  random_image
rescue
  puts "Generic error fetching image"
  random_image
end
# standard:enable Security/Open

def new_image
  {
    io: fetch_new_image,
    filename: "#{Faker::Lorem.characters(number: 8)}_faker_image.jpg"
  }
end
