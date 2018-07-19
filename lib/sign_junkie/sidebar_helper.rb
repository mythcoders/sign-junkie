# frozen_string_literal: true

module SignJunkie
  # Helpers with the sidebar
  module SidebarHelper
    def profile_link
      { href: edit_user_registration_path }
    end

    def sidebar_link(link, active_if)
      { class: ('active' if active_if), href: link }
    end

    # def users_controller?
    #   controller.class == ControlPanel::UsersController
    # end
    #
    # def audits_controller?
    #   controller.class == ControlPanel::AuditsController
    # end
    #
    # def reports_controller?
    #   controller.class == ControlPanel::ReportsController
    # end
    #
    # def products_controller?
    #   controller.class == ControlPanel::ProductsController ||
    #       controller.class == ControlPanel::PricesController ||
    #       controller.class == ControlPanel::ImagesController
    # end
    #
    # def customers_controller?
    #   controller.class == ControlPanel::CustomersController ||
    #       controller.class == ControlPanel::AddressesController ||
    #       controller.class == ControlPanel::NotesController
    # end
    #
    # def employee_controller?
    #   controller.class == ControlPanel::EmployeesController
    # end
    #
    # def order_controller?
    #   controller.class == ControlPanel::OrdersController
    # end

    def cp_home_action?(action)
      controller.class == Admin::DashboardController &&
          controller.action_name == action
    end

    def disabled_link
      { href: '#',
        onclick: "'alert('#{t('feature_un')}');'" }
    end
  end
end
