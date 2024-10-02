defmodule JustTravel.CartsTest do
  use JustTravel.DataCase

  alias JustTravel.Carts

  describe "carts" do
    alias JustTravel.Carts.Cart

    import JustTravel.CartsFixtures

    @invalid_attrs %{}

    test "list_carts/0 returns all carts" do
      cart = cart_fixture()
      assert Carts.list_carts() == [cart]
    end

    test "get_cart!/1 returns the cart with given id" do
      cart = cart_fixture()
      assert Carts.get_cart!(cart.id) == cart
    end

    test "create_cart/1 with valid data creates a cart" do
      valid_attrs = %{}

      assert {:ok, %Cart{}} = Carts.create_cart(valid_attrs)
    end

    test "update_cart/2 with valid data updates the cart" do
      cart = cart_fixture()
      update_attrs = %{}

      assert {:ok, %Cart{}} = Carts.update_cart(cart, update_attrs)
    end

    test "delete_cart/1 deletes the cart" do
      cart = cart_fixture()
      assert {:ok, %Cart{}} = Carts.delete_cart(cart)
      assert_raise Ecto.NoResultsError, fn -> Carts.get_cart!(cart.id) end
    end

    test "change_cart/1 returns a cart changeset" do
      cart = cart_fixture()
      assert %Ecto.Changeset{} = Carts.change_cart(cart)
    end
  end

  describe "ticket_carts" do
    alias JustTravel.Carts.TicketCart

    import JustTravel.CartsFixtures

    @invalid_attrs %{cart_id: -1, ticket_id: -1}

    test "list_cart_items_by_cart_id/1 returns all ticket_carts" do
      cart = cart_fixture()
      %{ticket_id: ticket_id_1} = ticket_cart_fixture(%{cart_id: cart.id})
      %{ticket_id: ticket_id_2} = ticket_cart_fixture(%{cart_id: cart.id})
      _3 = ticket_cart_fixture()
      _4 = ticket_cart_fixture()

      assert [%{id: ^ticket_id_1}, %{id: ^ticket_id_2}] =
               Carts.list_cart_items_by_cart_id(cart.id)
    end

    test "list_ticket_carts/0 returns all ticket_carts" do
      ticket_cart = ticket_cart_fixture()
      assert Carts.list_ticket_carts() == [ticket_cart]
    end

    test "get_ticket_cart!/1 returns the ticket_cart with given id" do
      ticket_cart = ticket_cart_fixture()
      assert Carts.get_ticket_cart!(ticket_cart.id) == ticket_cart
    end

    test "create_ticket_cart/1 with valid data creates a ticket_cart" do
      valid_attrs = ticket_cart_attrs_fixture()

      assert {:ok, %TicketCart{}} = Carts.create_ticket_cart(valid_attrs)
    end

    test "create_ticket_cart/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Carts.create_ticket_cart(@invalid_attrs)
    end

    test "update_ticket_cart/2 with valid data updates the ticket_cart" do
      ticket_cart = ticket_cart_fixture()
      update_attrs = %{}

      assert {:ok, %TicketCart{}} =
               Carts.update_ticket_cart(ticket_cart, update_attrs)
    end

    test "update_ticket_cart/2 with invalid data returns error changeset" do
      ticket_cart = ticket_cart_fixture()
      assert {:error, %Ecto.Changeset{}} = Carts.update_ticket_cart(ticket_cart, @invalid_attrs)
      assert ticket_cart == Carts.get_ticket_cart!(ticket_cart.id)
    end

    test "delete_ticket_cart/1 deletes the ticket_cart" do
      ticket_cart = ticket_cart_fixture()
      assert {:ok, %TicketCart{}} = Carts.delete_ticket_cart(ticket_cart)
      assert_raise Ecto.NoResultsError, fn -> Carts.get_ticket_cart!(ticket_cart.id) end
    end

    test "change_ticket_cart/1 returns a ticket_cart changeset" do
      ticket_cart = ticket_cart_fixture()
      assert %Ecto.Changeset{} = Carts.change_ticket_cart(ticket_cart)
    end
  end
end
