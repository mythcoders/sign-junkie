# frozen_string_literal: true

json.addons @project.addons do |addon|
  json.id addon.id
  json.name "#{addon.name} - #{number_to_currency(addon.price)}"
  json.price addon.price
end

stencils = @project.stencils.map { |s| { id: s.id, name: s.name } }

if @workshop.allow_custom_projects?
  stencils << { id: '$custom', name: '- Custom -' }
end

json.stencils stencils

