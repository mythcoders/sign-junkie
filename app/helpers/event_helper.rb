module EventHelper
  def ticket_dropdown(form, event)
    disabled = event.tickets_available.negative?

    content_tag :div, class: 'input-group' do
      concat(content_tag(:div, class: 'input-group-prepend') do
        ticket_go_back_button
      end)
      concat(ticket_select(form, event, disabled))
      concat(content_tag(:div, class: 'input-group-append') do
        ticket_add_cart_button(disabled)
      end)
    end
  end

  private

  def ticket_go_back_button
    link_to 'Go Back', events_path, class: 'btn btn-outline-secondary'
  end

  def ticket_select(form, event, disabled)
    classes = { class: 'custom-select' }
    classes[:disabled] = 'disabled' if disabled
    form.select(:quantity, ticket_dropdown_items(event.tickets_available), {}, classes)
  end

  def ticket_add_cart_button(disabled)
    classes = { class: 'btn btn-outline-success', type: 'submit',
                title: 'Add to cart', 'data-js-change-quantity-button': '' }
    classes[:disabled] = 'disabled' if disabled
    content_tag(:button, classes) do
      fa_solid 'cart-plus'
    end
  end

  def ticket_dropdown_items(quantity)
    if quantity.positive?
      ((1..product_qty).map { |i| [i, i] })
    else
      ['Sorry, this event is sold out.']
    end
  end
end
