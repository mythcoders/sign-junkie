module Admin
  class DashboardController < AdminController
    before_action :populate_changelog, only: %i[about]
    before_action :get_new_customers, only: %i[index]

    private

    def get_new_customers
      @new_customers = User.recently_created.count
      @new_invoices = Invoice.recently_created.count
    end

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