defmodule JustTravelWeb.Schema do
  @moduledoc """
  Absinthe schema
  """
  use Absinthe.Schema

  import AbsintheErrorPayload.Payload
  import_types(AbsintheErrorPayload.ValidationMessageTypes)

  payload_object(:payload_id, :id)

  alias JustTravel.Carts
  alias JustTravel.Tickets
  alias JustTravel.Tickets.Ticket

  object :ticket do
    field :id, :id
    field :name, :string
    field :city, :string
    field :price, :float
    field :description, :string
  end

  object :cart do
    field :items, list_of(:ticket)
  end

  union :entry do
    description("Pagination entries")

    # List all possible types
    types([:ticket])

    resolve_type(fn
      %Ticket{}, _ -> :ticket
    end)
  end

  object :pagination do
    field :page_number, non_null(:integer)
    field :page_size, non_null(:integer)
    field :total_entries, non_null(:integer)
    field :total_pages, non_null(:integer)
    field :entries, non_null(list_of(:entry))
  end

  query do
    @desc "Retornar uma lista de ingressos por cidade"
    field :tickets_by_city, :pagination do
      arg(:city, :string, default_value: "*")
      # Add page argument
      arg(:page, :integer, default_value: 1)
      # Add page_size argument
      arg(:page_size, :integer, default_value: 10)

      resolve(fn %{city: city, page: page, page_size: page_size}, _ ->
        page = Tickets.list_tickets_by_city(city, page, page_size)

        page_view = %{page | entries: Enum.map(page.entries, &ticket/1)}

        {:ok, page_view}
      end)
    end

    @desc "Retornar detalhes de um ingresso por ID"
    field :ticket, :ticket do
      arg(:id, non_null(:id))

      resolve(fn %{id: id}, _ ->
        {:ok, Tickets.get_ticket!(id) |> ticket()}
      end)
    end

    @desc "Retornar tickets de um carrinho por ID"
    field :cart, non_null(:cart) do
      arg(:id, non_null(:id))

      resolve(fn %{id: id}, _ ->
        items = Carts.list_cart_items_by_cart_id(id) |> Enum.map(&ticket/1)

        {:ok, %{items: items}}
      end)
    end
  end

  mutation do
    @desc "Adiciona um ticket no carrinho e retorna o id da associação criada."
    field :add_ticket_to_cart, non_null(:payload_id) do
      arg(:ticket_id, non_null(:id))
      arg(:cart_id, non_null(:id))

      resolve(fn %{ticket_id: ticket_id, cart_id: cart_id}, _ ->
        with {:ok, ticket_cart} <- Carts.add_ticket_to_cart(cart_id, ticket_id) do
          {:ok, ticket_cart.id}
        end
      end)

      middleware(&build_payload/2)
    end
  end

  def ticket(ticket) do
    Map.update!(ticket, :price, &Decimal.to_float/1)
  end
end
