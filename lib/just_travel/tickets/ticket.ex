defmodule JustTravel.Tickets.Ticket do
  @moduledoc """
  Ticket schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "tickets" do
    field :name, :string
    field :description, :string
    field :city, :string
    field :price, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ticket, attrs) do
    ticket
    |> cast(attrs, [:name, :city, :price, :description])
    |> validate_required([:name, :city, :price, :description])
  end
end
