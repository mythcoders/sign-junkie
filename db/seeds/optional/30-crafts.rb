# frozen_string_literal: true

puts "Creating stencils categories..."
2.times do
  StencilCategory.create(name: "#{Faker::Commerce.department} #{SecureRandom.hex(4)}")
end

puts "Creating stencils..."
6.times do
  stencil = Stencil.create(
    name: "#{Faker::Movies::StarWars.quote} #{SecureRandom.hex(4)}",
    category: StencilCategory.all.sample
  )

  next unless stencil.valid?
  attach_images(stencil.stencil_images, 2)
end

puts "Creating addons..."
3.times do
  addon = Addon.create(
    name: "#{Faker::Commerce.material} #{Faker::House.room} #{Faker::House.furniture} #{SecureRandom.hex(4)}",
    price: Faker::Commerce.price
  )

  next unless addon.valid?
  attach_images(addon.addon_images, 2)
end

puts "Creating projects..."
6.times do
  project = Project.create(
    name: "#{Faker::Commerce.product_name} #{SecureRandom.hex(4)}",
    material_price: Faker::Commerce.price,
    instructional_price: Faker::Commerce.price,
    addons: Addon.all.sample(2),
    stencils: Stencil.all.sample(4)
  )

  next unless project.valid?
  attach_images(project.project_images, 2)
end
