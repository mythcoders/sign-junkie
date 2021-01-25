# frozen_string_literal: true

module Security
  class RegistrationsController < Devise::RegistrationsController
    # include Recaptcha::Adapters::ControllerMethods
    # include Recaptcha::Adapters::ViewMethods

    def create
      if verify_recaptcha(model: resource)
        super
      else
        recaptcha_error
      end
    end

    private

    def recaptcha_error
      self.resource = resource_class.new sign_up_params
      resource.validate
      resource.errors.add(:base, "Registration Error. Please try again")
      # this part is different from the devise wiki, since we don't use a create template, only new
      respond_with_navigational(resource) { render :new }
    end
  end
end
