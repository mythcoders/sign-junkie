# frozen_string_literal: true

# Fixed https://sentry.io/organizations/mythcoders/issues/2133096965/
# taken from https://github.com/rails/rails/issues/37672
ActiveSupport.on_load(:action_view) do
  include ActionText::ContentHelper
  include ActionText::TagHelper
end
