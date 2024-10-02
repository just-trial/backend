defmodule JustTravelWeb.Schema do
  use Absinthe.Schema

  alias JustTravel.Tickets

  object :ticket do
    field :id, :id
    field :name, :string
    field :city, :string
    field :price, :float
    field :description, :string
  end

  query do
    @desc "Retornar uma lista de ingressos por cidade"
    field :tickets_by_city, list_of(:ticket) do
      arg :city, non_null(:string)
      resolve fn %{city: city}, _ ->
        {:ok, Tickets.list_tickets(%{city: city}) |> Enum.map(&ticket/1)}
      end
    end

    @desc "Retornar detalhes de um ingresso por ID"
    field :ticket, :ticket do
      arg :id, non_null(:id)
      resolve fn %{id: id}, _ ->
        {:ok, Tickets.get_ticket!(id) |> ticket()}
      end
    end
  end

  def ticket(ticket) do
    Map.update!(ticket, :price, &Decimal.to_float/1)
  end
end
