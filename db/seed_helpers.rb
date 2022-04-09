# frozen_string_literal: true

require "open-uri"

def random_image
  puts "Fetching backup image"
  URI.open("https://robohash.org/#{SecureRandom.hex(8)}.png?set=set4")
rescue
  puts "Fatal error!"
end

# standard:disable Security/Open
def fetch_new_image
  puts "Fetching image"
  URI.open(Faker::Avatar.image)
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
    filename: "#{SecureRandom.hex(8)}_faker_image.jpg"
  }
end

def attach_images(images, count = 2)
  count.times do
    new_image.tap do |image|
      next if image.nil?

      images.attach(image)
    end
  end
end
