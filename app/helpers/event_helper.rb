module EventHelper
  def add_cart_helper(product_qty)
    if product_qty.positive? && product_qty < 10
      ((1..product_qty).map { |i| [i, i] })
    else
      ((1..10).map { |i| [i, i] })
    end
  end
end
