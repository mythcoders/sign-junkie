# frozen_string_literal: true

module Admin
  module ColorsHelper
    def color_types
      Color.color_types.to_a.map do |t|
        OpenStruct.new(label: Color.human_enum_name(:color_type, t[0]), value: t[0])
      end.sort_by(&:label)
    end
  end
end
