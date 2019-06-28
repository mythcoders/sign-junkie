# frozen_string_literal: true

module WorkshopHelper
  def ticket_dropdown(form, workshop)
    disabled = !workshop.can_purchase?

    content_tag :div, class: 'input-group' do
      concat(ticket_select(form, workshop, disabled))
      concat(content_tag(:div, class: 'input-group-append') do
        ticket_add_cart_button(disabled)
      end)
    end
  end

  private

  def ticket_select(form, workshop, disabled)
    classes = { class: 'custom-select' }
    classes[:disabled] = 'disabled' if disabled
    form.select(:quantity, ticket_dropdown_items(workshop), {}, classes)
  end

  def ticket_add_cart_button(disabled)
    classes = { class: 'btn btn-success', type: 'submit',
                title: 'Add to cart', 'data-js-change-quantity-button': '' }
    classes[:disabled] = 'disabled' if disabled
    content_tag(:button, classes) do
      concat(fa_solid('cart-plus'))
      concat(content_tag(:span, ' Add to Cart'))
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
    elsif workshop.private?
      ((Workshop.private_min..Workshop.private_max).map { |i| [i, i] })
    else
      ((1..workshop.seats_available).map { |i| [i, i] })
    end
  end
end
