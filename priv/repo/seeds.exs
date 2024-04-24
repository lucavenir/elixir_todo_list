# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Ecommerce.Repo.insert!(%Ecommerce.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

for title <- ["Home", "Electronics", "Books", "Clothing", "Toys"] do
  {:ok, _} = Ecommerce.Catalog.create_category(%{title: title})
end
