# frozen_string_literal: true

# Helpers with the sidebar
module SidebarHelper
  ITEMS = [
    { name: 'Dashboard', icon: '', controllers: '' }
  ].freeze

  def sidebar_link(link, active_if)
    { class: ('active' if active_if), href: link }
  end

  def workshops_controller?
    controller.class == Admin::WorkshopsController
  end

  def customers_controller?
    controller.class == Admin::CustomersController
  end

  def employees_controller?
    controller.class == Admin::EmployeesController
  end

  def projects_controller?
    controller.class == Admin::ProjectsController
  end

  def designs_controller?
    controller.class == Admin::StencilsController
  end

  def invoices_controller?
    controller.class == Admin::InvoicesController
  end

  def admin_home_action?(action)
    controller.class == Admin::DashboardController && controller.action_name == action
  end
end
