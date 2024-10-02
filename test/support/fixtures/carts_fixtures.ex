defmodule JustTravel.CartsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JustTravel.Carts` context.
  """

  alias JustTravel.TicketsFixtures

  def ticket_cart_attrs_fixture(attrs \\ %{}) do
    # Create a cart if cart_id is not provided
    cart = Map.get(attrs, :cart_id) || cart_fixture()

    # Create a ticket if ticket_id is not provided
    ticket = Map.get(attrs, :ticket_id) || TicketsFixtures.ticket_fixture()

    # Combine the attributes, ensuring cart_id and ticket_id are present
    attrs
    |> Enum.into(%{
      cart_id: cart.id,
      ticket_id: ticket.id
    })
  end

  @doc """
  Generate a ticket_cart.
  """
  def ticket_cart_fixture(attrs \\ %{}) do
    valid_attrs = ticket_cart_attrs_fixture(attrs)

    # Create the ticket_cart using the valid attributes
    {:ok, ticket_cart} = JustTravel.Carts.create_ticket_cart(valid_attrs)

    ticket_cart
  end

  @doc """
  Generate a cart.
  """
  def cart_fixture(attrs \\ %{}) do
    {:ok, cart} =
      attrs
      |> Enum.into(%{})
      |> JustTravel.Carts.create_cart()

    cart
  end
end
