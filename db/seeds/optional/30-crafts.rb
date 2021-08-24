# frozen_string_literal: true

puts "Creating stencils categories..."
2.times do
  StencilCategory.create(name: Faker::Commerce.department)
end

puts "Creating stencils..."
6.times do
  stencil = Stencil.create(name: Faker::Movies::StarWars.quote,
    category: StencilCategory.all.sample)
  stencil.image.attach(new_image)
end

puts "Creating addon..."

3.times do
  addon = Addon.create(name: "#{Faker::Commerce.material} #{Faker::House.room} #{Faker::House.furniture}",
    price: Faker::Commerce.price)
  addon.addon_images.attach([new_image, new_image])
end

puts "Creating project..."

6.times do
  project = Project.create(name: Faker::Commerce.product_name,
    material_price: Faker::Commerce.price,
    instructional_price: Faker::Commerce.price,
    addons: Addon.all.sample(2),
    stencils: Stencil.all.sample(4))
  project.project_images.attach([new_image, new_image])
end
