module WorkshopHelper

  def ticket_dropdown(form, workshop)
    disabled = !workshop.can_purchase?

    content_tag :div, class: 'input-group' do
      concat(content_tag(:div, class: 'input-group-prepend') do
        ticket_go_back_button
      end)
      concat(ticket_select(form, workshop, disabled))
      concat(content_tag(:div, class: 'input-group-append') do
        ticket_add_cart_button(disabled)
      end)
    end
  end

  def cart_dropdown(form, cart_item)
    html_metadata = {
      class: 'custom-select',
      'data-js-cart-quantity': '',
      'data-cart-id': cart_item.id,
      'data-price': cart_item.workshop.ticket_price
    }
    form.select(:quantity, ticket_dropdown_items(cart_item.workshop), {}, html_metadata)
  end

  private

  def ticket_go_back_button
    link_to 'Go Back', workshops_path, class: 'btn btn-outline-secondary'
  end

  def ticket_select(form, workshop, disabled)
    classes = { class: 'custom-select' }
    classes[:disabled] = 'disabled' if disabled
    form.select(:quantity, ticket_dropdown_items(workshop), {}, classes)
  end

  def ticket_add_cart_button(disabled)
    classes = { class: 'btn btn-outline-success', type: 'submit',
                title: 'Add to cart', 'data-js-change-quantity-button': '' }
    classes[:disabled] = 'disabled' if disabled
    content_tag(:button, classes) do
      fa_solid 'cart-plus'
    end
  end

  def ticket_dropdown_items(workshop)
    if workshop.projects.count <= 0
      Raven.capture_message('Workshop posted without any projects!',
                            level: :warning,
                            extra: { 'workshop_id': workshop.id })
      ['Sorry, this workshop is unavailable at this time.']
    elsif workshop.seats_available <= 0
      ['Sorry, this workshop has already sold out.']
    elsif !workshop.can_purchase?
      ['Sorry, this workshop is unavailable at this time.']
    elsif workshop.is_private?
      ((Workshop.private_min..Workshop.private_max).map { |i| [i, i] })
    else
      ((1..workshop.seats_available).map { |i| [i, i] })
    end
  end
end
