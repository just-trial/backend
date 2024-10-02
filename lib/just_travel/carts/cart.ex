defmodule JustTravel.Carts.Cart do
  @moduledoc """
  Cart schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "carts" do
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(cart, attrs) do
    cart
    |> cast(attrs, [])
    |> validate_required([])
  end
end
