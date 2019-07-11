# frozen_string_literal: true

module Admin
  class DashboardController < AdminController
    before_action :populate_changelog, only: %i[about]
    before_action :set_new_customers, only: %i[index]

    private

    def set_new_customers
      @new_customers = User.recently_created.count
      @new_invoices = Invoice.recently_created.count
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
