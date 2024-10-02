defmodule JustTravel.TicketsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `JustTravel.Tickets` context.
  """

  @doc """
  Generate a ticket.
  """
  def ticket_fixture(attrs \\ %{}) do
    {:ok, ticket} =
      attrs
      |> Enum.into(%{
        city: "some city",
        description: "some description",
        name: "some name",
        price: "120.5"
      })
      |> JustTravel.Tickets.create_ticket()

    ticket
  end
end
