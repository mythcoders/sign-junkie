# frozen_string_literal: true

module ApplicationHelper
  include IconHelper
  include SidebarHelper

  USER_ROLES = [
    { name: 'Customer', id: 1 },
    { name: 'Employee', id: 2 },
    { name: 'Supervisor', id: 4 },
    { name: 'IT Operator', id: 8 }
  ].freeze

  PAYMENT_METHODS = [
    { name: 'Credit/Debit Card', id: :card },
    { name: 'PayPal', id: :pay_pal }
  ].freeze

  def admin?
    controller.class.superclass == Admin::ApplicationController
  end
  delegate :control_panel?, to: :admin?

  def lifp(value, format = :default)
    l(value, format: format) if value.present?
  end

  # Handles HTML title element
  def page_title(*titles)
    @page_title ||= []
    @page_title.push(*titles.compact) if titles.any?
    @page_title.join(" \u00b7 ") # Segments are separated by middot
  end

  def date_out(start_date, end_date)
    if start_date.day == end_date.day
      "#{start_date.strftime('%b %d, %Y %I:%M %p')} - #{end_date.strftime('%I:%M %p')}"
    else
      "#{start_date.strftime('%b %d, %Y %I:%M %p')} - #{end_date.strftime('%b %d, %Y %I:%M %p')}"
    end
  end

  # Render the error messages for given objects
  def error_messages_for(*objects)
    objects = objects.map { |o| o.is_a?(String) ? instance_variable_get("@#{o}") : o }.compact
    errors = objects.map { |o| o.errors.full_messages }.flatten
    render_error_messages(errors)
  end

  private

  # Renders a list of error messages
  def render_error_messages(errors)
    html = ''
    if errors.present?
      html += "<div id='errorExplanation' class='text-danger'><ul>\n"
      errors.each do |error|
        html += "<li>#{h error}</li>\n"
      end
      html += "</ul><br/></div>\n"
    end
    html.html_safe
  end
end
