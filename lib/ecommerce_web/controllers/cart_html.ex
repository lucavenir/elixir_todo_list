defmodule EcommerceWeb.CartHTML do
  use EcommerceWeb, :html

  alias Ecommerce.ShoppingCart

  embed_templates "cart_html/*"

  def currency_to_str(%Decimal{} = value) do
    rounded = Decimal.round(value, 2)
    "€ #{rounded}"
  end
end
