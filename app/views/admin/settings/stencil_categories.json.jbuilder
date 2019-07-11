# frozen_string_literal: true

json.array! @data do |node|
  node.to_builder
end
