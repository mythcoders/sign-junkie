# frozen_string_literal: true

FactoryBot.define do
  factory :workshop_project do
    workshop
    project
  end

  factory :workshop_project_with_stencils do
    workshop
    project { create(:project, :with_stencils, :with_addons) }
  end
end
