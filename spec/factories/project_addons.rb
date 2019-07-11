# frozen_string_literal: true

FactoryBot.define do
  factory :project_addon do
    project
    addon
  end
end
