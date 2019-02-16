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
      controller.class == Admin::DesignsController
    end

    def categories_controller?
      controller.class == Admin::DesignCategoriesController
    end

    def addons_controller?
      controller.class == Admin::AddonsController
    end

    def order_controller?
      controller.class == Admin::OrdersController
    end

    def admin_home_action?(action)
      controller.class == Admin::DashboardController &&
        controller.action_name == action
    end

    def disabled_link
      { href: '#',
        onclick: "alert('#{t('feature_un')}');" }
    end
  end
end
