module Admin
  class DashboardController < ApplicationController
    before_action :populate_changelog, only: %i[about]

    private

    def populate_changelog
      if File.exist?(file_path)
        markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
        contents = File.read(file_path)
        @markdown = markdown.render(contents)
      end
    end

    def file_path
      Rails.root.join('CHANGELOG.md')
    end
  end
end