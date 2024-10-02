defmodule JustTravel.TicketsTest do
  use JustTravel.DataCase

  alias JustTravel.Tickets

  describe "tickets" do
    alias JustTravel.Tickets.Ticket

    import JustTravel.TicketsFixtures

    @invalid_attrs %{name: nil, description: nil, city: nil, price: nil}

    test "list_tickets/0 returns all tickets" do
      ticket = ticket_fixture()
      assert Tickets.list_tickets() == [ticket]
    end

    test "list_tickets_by_city/0 returns all tickets by a given city" do
      ticket_1 = ticket_fixture(%{city: "Grifinória"})
      ticket_2 = ticket_fixture(%{city: "Grifinória"})
      _ticket_3 = ticket_fixture(%{city: "Sunserina"})
      _ticket_4 = ticket_fixture(%{city: "Corvinal"})
      _ticket_5 = ticket_fixture(%{city: "Lufa-Lufa"})

      assert Tickets.list_tickets_by_city("Grifinória") == %Scrivener.Page{
               page_number: 1,
               page_size: 10,
               total_entries: 2,
               total_pages: 1,
               entries: [ticket_1, ticket_2]
             }
    end

    test "get_ticket!/1 returns the ticket with given id" do
      ticket = ticket_fixture()
      assert Tickets.get_ticket!(ticket.id) == ticket
    end

    test "create_ticket/1 with valid data creates a ticket" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        city: "some city",
        price: "120.5"
      }

      assert {:ok, %Ticket{} = ticket} = Tickets.create_ticket(valid_attrs)
      assert ticket.name == "some name"
      assert ticket.description == "some description"
      assert ticket.city == "some city"
      assert ticket.price == Decimal.new("120.5")
    end

    test "create_ticket/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tickets.create_ticket(@invalid_attrs)
    end

    test "update_ticket/2 with valid data updates the ticket" do
      ticket = ticket_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        city: "some updated city",
        price: "456.7"
      }

      assert {:ok, %Ticket{} = ticket} = Tickets.update_ticket(ticket, update_attrs)
      assert ticket.name == "some updated name"
      assert ticket.description == "some updated description"
      assert ticket.city == "some updated city"
      assert ticket.price == Decimal.new("456.7")
    end

    test "update_ticket/2 with invalid data returns error changeset" do
      ticket = ticket_fixture()
      assert {:error, %Ecto.Changeset{}} = Tickets.update_ticket(ticket, @invalid_attrs)
      assert ticket == Tickets.get_ticket!(ticket.id)
    end

    test "delete_ticket/1 deletes the ticket" do
      ticket = ticket_fixture()
      assert {:ok, %Ticket{}} = Tickets.delete_ticket(ticket)
      assert_raise Ecto.NoResultsError, fn -> Tickets.get_ticket!(ticket.id) end
    end

    test "change_ticket/1 returns a ticket changeset" do
      ticket = ticket_fixture()
      assert %Ecto.Changeset{} = Tickets.change_ticket(ticket)
    end
  end
end
