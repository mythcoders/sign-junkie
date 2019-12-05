# frozen_string_literal: true

puts 'Creating workshops...'

5.times do
  start_date = Faker::Date.between(Date.today, Date.today + 6.weeks)
  end_date = start_date + 3.hours
  purchase_start_date = Time.zone.today - 2.hours
  purchase_end_date = start_date - 2.days

  shop = Workshop.create!(name: "#{Faker::Esport.event} #{Faker::Hipster.word}",
                          description: Faker::Hipster.paragraph,
                          projects: Project.all.sample(3),
                          purchase_start_date: purchase_start_date,
                          purchase_end_date: purchase_end_date,
                          start_date: start_date,
                          end_date: end_date,
                          workshop_type: WorkshopType.all.sample,
                          is_for_sale: true)
  shop.workshop_images.attach([new_image, new_image])
end
