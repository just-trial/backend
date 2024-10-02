defmodule JustTravelWeb.SchemaTest do
  use JustTravelWeb.ConnCase, async: true
  alias JustTravel.Tickets

  test "query ticket by id" do
    # Setup: inserir alguns tickets no banco de dados
    {:ok, ticket_1} = Tickets.create_ticket(%{name: "Order of The Phoenix", city: "Salvador", price: 90.00, description: "Good!"})

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
    {:ok, _ticket_1} = Tickets.create_ticket(%{name: "Concert", city: "São Paulo", price: 100.00, description: "Awesome concert"})
    {:ok, _ticket_2} = Tickets.create_ticket(%{name: "Orchestra", city: "São Paulo", price: 10.00, description: "Good one"})
    {:ok, _ticket_3} = Tickets.create_ticket(%{name: "Tachos Day", city: "Florianópolis", price: 15.00, description: "Nhamiii"})

    query = """
    {
      ticketsByCity(city: "São Paulo") {
        name
        city
        price
      }
    }
    """

    conn = build_conn()
    result = post(conn, "/graphql", %{query: query})

    assert json_response(result, 200)["data"]["ticketsByCity"] == [
      %{"city" => "São Paulo", "name" => "Concert", "price" => 100.0},
      %{"city" => "São Paulo", "name" => "Orchestra", "price" => 10.0}
    ]
  end
end
