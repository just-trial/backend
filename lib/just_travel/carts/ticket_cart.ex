defmodule JustTravel.Carts.TicketCart do
  @moduledoc """
  TicketCart schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias JustTravel.Carts.Cart
  alias JustTravel.Tickets.Ticket

  schema "ticket_carts" do
    belongs_to :cart, Cart
    belongs_to :ticket, Ticket

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket_cart, attrs) do
    ticket_cart
    |> cast(attrs, [:cart_id, :ticket_id])
    |> validate_required([:cart_id, :ticket_id])
    |> foreign_key_constraint(:cart_id, message: "Carrinho deve existir")
    |> foreign_key_constraint(:ticket_id, message: "Ticket deve existir")
  end
end
