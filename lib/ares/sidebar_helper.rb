# frozen_string_literal: true

module Ares
  # Helpers with the sidebar
  module SidebarHelper
    def profile_link
      { href: edit_user_registration_path }
    end

    def sidebar_link(link, active_if)
      { class: ('active' if active_if), href: link }
    end

    # def users_controller?
    #   controller.class == Admin::UsersController
    # end

    def audits_controller?
      controller.class == Admin::AuditsController
    end
    #
    # def reports_controller?
    #   controller.class == Admin::ReportsController
    # end
    #
    # def products_controller?
    #   controller.class == Admin::ProductsController ||
    #       controller.class == Admin::PricesController ||
    #       controller.class == Admin::ImagesController
    # end

    def customers_controller?
      controller.class == Admin::CustomersController ||
        controller.class == Admin::AddressesController ||
        controller.class == Admin::NotesController
    end

    def employees_controller?
      controller.class == Admin::EmployeesController
    end

    # def order_controller?
    #   controller.class == Admin::OrdersController
    # end

    def admin_home_action?(action)
      controller.class == Admin::DashboardController &&
        controller.action_name == action
    end

    def disabled_link
      { href: '#',
        onclick: "'alert('#{t('feature_un')}');'" }
    end
  end
end
