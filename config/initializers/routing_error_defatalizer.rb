# frozen_string_literal: true

if Rails.application.config.lograge.enabled
  module ActionDispatch
    class DebugExceptions
      alias_method :old_log_error, :log_error

      def log_error(request, wrapper)
        exception = wrapper.exception
        if exception.is_a?(ActionController::RoutingError)
          data = {
            method: request.env["REQUEST_METHOD"],
            path: request.env["REQUEST_PATH"],
            status: wrapper.status_code,
            error: "#{exception.class.name}: #{exception.message}"
          }
          formatted_message = Lograge.formatter.call(data)
          logger(request).send(Lograge.log_level, formatted_message)
        else
          old_log_error request, wrapper
        end
      end
    end
  end
end
