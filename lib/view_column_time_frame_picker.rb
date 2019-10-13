# frozen_string_literal: true

class ViewColumnTimeFramePicker < Wice::Columns::ViewColumn #:nodoc:
  include ActionView::Helpers::FormOptionsHelper

  OPTIONS = [
    ['--', ''],
    ['Future dates only', 'future'],
    ['Past dates only', 'past']
  ].freeze

  def render_filter_internal(params)
    @query, _, @parameter_name, @dom_id = form_parameter_name_id_and_query('')

    css_class = 'custom-select input-sm ' + (auto_reload ? 'auto-reload' : '')
    select_options = { name: @parameter_name + '[]', id: @dom_id, class: css_class }
    params_for_select = params.is_a?(Hash) && params.empty? ? [nil] : params

    '<div class="timeframe-container">'.html_safe +
      content_tag(:select,
                  options_for_select(OPTIONS, params_for_select),
                  select_options) + '</div>'.html_safe
  end

  def yield_declaration_of_column_filter
    {
      templates: [@query],
      ids: [@dom_id]
    }
  end
end

class ConditionsGeneratorColumnTimeFramePicker < Wice::Columns::ConditionsGeneratorColumn #:nodoc:
  def generate_conditions(table_alias, opts) #:nodoc:
    opts = opts.is_a?(Array) && opts.size == 1 ? opts[0] : opts

    case opts
    when 'future'
      [" #{@column_wrapper.alias_or_table_name(table_alias)}.#{@column_wrapper.name} > now()"]
    when 'past'
      [" #{@column_wrapper.alias_or_table_name(table_alias)}.#{@column_wrapper.name} < now()"]
    end
  end
end
