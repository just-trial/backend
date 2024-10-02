defmodule JustTravelWeb.SchemaTest do
  use JustTravelWeb.ConnCase, async: true
  alias JustTravel.Carts
  alias JustTravel.Tickets

  setup %{} do
    # Setup: insert initial data
    {:ok, ticket_1} =
      Tickets.create_ticket(%{
        name: "Concert",
        city: "São Paulo",
        price: 100.00,
        description: "Awesome concert"
      })

    {:ok, ticket_2} =
      Tickets.create_ticket(%{
        name: "Orchestra",
        city: "São Paulo",
        price: 10.00,
        description: "Good one"
      })

    {:ok, ticket_3} =
      Tickets.create_ticket(%{
        name: "Tachos Day",
        city: "São Paulo",
        price: 15.00,
        description: "Nhamiii"
      })

    {:ok, cart} = Carts.create_cart()

    {:ok,
     ticket_1: ticket_1, ticket_2: ticket_2, ticket_3: ticket_3, cart: cart, conn: build_conn()}
  end

  test "query ticket by id" do
    # Setup: inserir alguns tickets no banco de dados
    {:ok, ticket_1} =
      Tickets.create_ticket(%{
        name: "Order of The Phoenix",
        city: "Salvador",
        price: 90.00,
        description: "Good!"
      })

    # Define the query with a placeholder for the ID
    query = """
    query($id: ID!) {
      ticket(id: $id) {
        name
        city
        price
      }
    }
    """

    # Define the variables for the query
    variables = %{id: ticket_1.id}

    conn = build_conn()
    result = post(conn, "/graphql", %{query: query, variables: variables})

    assert json_response(result, 200)["data"]["ticket"] == %{
             "name" => "Order of The Phoenix",
             "city" => "Salvador",
             "price" => 90.0
           }
  end

  test "query tickets by city" do
    query = """
    {
      ticketsByCity(city: "São Paulo") {
        pageNumber
        pageSize
        totalEntries
        totalPages
        entries {
          ... on Ticket {
            name
            city
            price
          }
        }
      }
    }
    """

    conn = build_conn()
    result = post(conn, "/graphql", %{query: query})

    assert json_response(result, 200)["data"]["ticketsByCity"] == %{
             "entries" => [
               %{
                 "city" => "São Paulo",
                 "name" => "Concert",
                 "price" => 100.0
               },
               %{
                 "city" => "São Paulo",
                 "name" => "Orchestra",
                 "price" => 10.0
               },
               %{"city" => "São Paulo", "name" => "Tachos Day", "price" => 15.0}
             ],
             "pageNumber" => 1,
             "pageSize" => 10,
             "totalEntries" => 3,
             "totalPages" => 1
           }
  end

  test "query tickets by city with pagination size" do
    # Define the query and variables for the request
    query = """
    query($city: String!, $page: Int!, $pageSize: Int!) {
      ticketsByCity(city: $city, page: $page, pageSize: $pageSize) {
        pageNumber
        pageSize
        totalEntries
        totalPages
        entries {
          ... on Ticket {
            name
            city
            price
          }
        }
      }
    }
    """

    variables = %{
      "city" => "São Paulo",
      "page" => 2,
      "pageSize" => 2
    }

    conn = build_conn()
    result = post(conn, "/graphql", %{query: query, variables: variables})

    assert json_response(result, 200)["data"]["ticketsByCity"] == %{
             "entries" => [%{"city" => "São Paulo", "name" => "Tachos Day", "price" => 15.0}],
             "pageNumber" => 2,
             "pageSize" => 2,
             "totalEntries" => 3,
             "totalPages" => 2
           }
  end

  test "list cart items", %{ticket_1: ticket_1, ticket_2: ticket_2, cart: cart, conn: conn} do
    # Add the ticket to the cart
    {:ok, _} = Carts.add_ticket_to_cart(cart.id, ticket_1.id)
    {:ok, _} = Carts.add_ticket_to_cart(cart.id, ticket_2.id)

    # Define the query and variables for the request
    query = """
    query($id: ID!) {
      cart(id: $id) {
          items {

            name
            city
            price
          }
      }
    }
    """

    variables = %{
      "id" => cart.id
    }

    result = post(conn, "/graphql", %{query: query, variables: variables})

    assert json_response(result, 200)["data"]["cart"]["items"] == [
             %{"city" => "São Paulo", "name" => "Concert", "price" => 100.0},
             %{"city" => "São Paulo", "name" => "Orchestra", "price" => 10.0}
           ]
  end

  test "mutation: add_ticket_to_cart adds a ticket to the cart and returns its id", %{
    ticket_1: ticket,
    cart: cart,
    conn: conn
  } do
    query = """
    mutation($ticketId: ID!, $cartId: ID!) {
      addTicketToCart(ticketId: $ticketId, cartId: $cartId) {
        successful
        result
      }
    }
    """

    variables = %{
      "ticketId" => ticket.id,
      "cartId" => cart.id
    }

    result = post(conn, "/graphql", %{query: query, variables: variables})

    result = json_response(result, 200)["data"]["addTicketToCart"]
    assert result["successful"]
    assert result["result"] |> String.to_integer() |> is_integer()
  end

  test "mutation: add_ticket_to_cart handling error changeset on API", %{
    cart: cart,
    conn: conn
  } do
    query = """
    mutation($ticketId: ID!, $cartId: ID!) {
      addTicketToCart(ticketId: $ticketId, cartId: $cartId) {
        successful
        messages {
          message
        }
      }
    }
    """

    variables = %{
      "ticketId" => -1,
      "cartId" => cart.id
    }

    result = post(conn, "/graphql", %{query: query, variables: variables})

    assert json_response(result, 200)["data"]["addTicketToCart"] == %{
             "messages" => [%{"message" => "Ticket deve existir"}],
             "successful" => false
           }
  end
end
