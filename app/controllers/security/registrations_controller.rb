# frozen_string_literal: true

module Security
  class RegistrationsController < Devise::RegistrationsController
    def create
      self.resource = resource_class.new sign_up_params

      if verify_recaptcha(model: resource, action: "registrations_new")
        super
      else
        my_recaptcha_error
      end
    end

    private

    def my_recaptcha_error
      resource.validate
      resource.errors.add(:base, "Registration Error. Please try again")
      # this part is different from the devise wiki, since we don't use a create template, only new
      respond_with_navigational(resource) { render :new }
    end
  end
end
