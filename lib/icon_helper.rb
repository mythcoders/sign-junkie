# frozen_string_literal: true

module IconHelper
  def fa_solid(icon, html_class = nil)
    tag.i class: "fas fa-#{icon} #{html_class}"
  end

  def fa_duo(icon, html_class = nil)
    tag.i class: "fad fa-#{icon} #{html_class}"
  end

  def fa_regular(icon, html_class = nil)
    tag.i class: "far fa-#{icon} #{html_class}"
  end

  def fa_spin(icon, html_class = nil)
    tag.i class: "fas fa-#{icon} #{html_class} fa-spin"
  end

  def fa_light(icon, html_class = nil)
    tag.i class: "fal fa-#{icon} #{html_class}"
  end

  def fa_brands(icon, html_class = nil)
    tag.i class: "fab fa-#{icon} #{html_class}"
  end
end
