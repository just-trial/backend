defmodule JustTravelWeb.SchemaTest do
  use JustTravelWeb.ConnCase, async: true
  alias JustTravel.Tickets

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
    # Setup: inserir alguns tickets no banco de dados
    {:ok, _ticket_1} =
      Tickets.create_ticket(%{
        name: "Concert",
        city: "São Paulo",
        price: 100.00,
        description: "Awesome concert"
      })

    {:ok, _ticket_2} =
      Tickets.create_ticket(%{
        name: "Orchestra",
        city: "São Paulo",
        price: 10.00,
        description: "Good one"
      })

    {:ok, _ticket_3} =
      Tickets.create_ticket(%{
        name: "Tachos Day",
        city: "Florianópolis",
        price: 15.00,
        description: "Nhamiii"
      })

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
               }
             ],
             "pageNumber" => 1,
             "pageSize" => 10,
             "totalEntries" => 2,
             "totalPages" => 1
           }
  end

  test "query tickets by city with pagination size" do
    # Setup: inserir alguns tickets no banco de dados
    {:ok, _ticket_1} =
      Tickets.create_ticket(%{
        name: "Concert",
        city: "São Paulo",
        price: 100.00,
        description: "Awesome concert"
      })

    {:ok, _ticket_2} =
      Tickets.create_ticket(%{
        name: "Orchestra",
        city: "São Paulo",
        price: 10.00,
        description: "Good one"
      })

    {:ok, _ticket_3} =
      Tickets.create_ticket(%{
        name: "Tachos Day",
        city: "São Paulo",
        price: 15.00,
        description: "Nhamiii"
      })

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
end
