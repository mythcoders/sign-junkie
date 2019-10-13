# frozen_string_literal: true

module Admin
  class DashboardController < AdminController
    before_action :populate_changelog, only: %i[about]
    before_action :set_stats, only: %i[index]

    private

    def set_stats
      @stats = AdminDashboardViewModel.new
    end

    def populate_changelog
      return unless File.exist?(file_path)

      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      contents = File.read(file_path)
      @markdown = markdown.render(contents)
    end

    def file_path
      Rails.root.join('CHANGELOG.md')
    end
  end
end
