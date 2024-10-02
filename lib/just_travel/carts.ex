defmodule JustTravel.Carts do
  @moduledoc """
  The Carts context.
  """

  import Ecto.Query, warn: false
  alias JustTravel.Repo

  alias JustTravel.Carts.TicketCart

  @doc """
  Returns the list of ticket_carts.

  ## Examples

      iex> list_ticket_carts()
      [%TicketCart{}, ...]

  """
  def list_ticket_carts do
    Repo.all(TicketCart)
  end

  @doc """
  Gets a single ticket_cart.

  Raises `Ecto.NoResultsError` if the Ticket cart does not exist.

  ## Examples

      iex> get_ticket_cart!(123)
      %TicketCart{}

      iex> get_ticket_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ticket_cart!(id), do: Repo.get!(TicketCart, id)

  @doc """
  Creates a ticket_cart.

  ## Examples

      iex> create_ticket_cart(%{field: value})
      {:ok, %TicketCart{}}

      iex> create_ticket_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ticket_cart(attrs \\ %{}) do
    %TicketCart{}
    |> TicketCart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ticket_cart.

  ## Examples

      iex> update_ticket_cart(ticket_cart, %{field: new_value})
      {:ok, %TicketCart{}}

      iex> update_ticket_cart(ticket_cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ticket_cart(%TicketCart{} = ticket_cart, attrs) do
    ticket_cart
    |> TicketCart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ticket_cart.

  ## Examples

      iex> delete_ticket_cart(ticket_cart)
      {:ok, %TicketCart{}}

      iex> delete_ticket_cart(ticket_cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ticket_cart(%TicketCart{} = ticket_cart) do
    Repo.delete(ticket_cart)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ticket_cart changes.

  ## Examples

      iex> change_ticket_cart(ticket_cart)
      %Ecto.Changeset{data: %TicketCart{}}

  """
  def change_ticket_cart(%TicketCart{} = ticket_cart, attrs \\ %{}) do
    TicketCart.changeset(ticket_cart, attrs)
  end

  alias JustTravel.Carts.Cart

  @doc """
  Returns the list of carts.

  ## Examples

      iex> list_carts()
      [%Cart{}, ...]

  """
  def list_carts do
    Repo.all(Cart)
  end

  @doc """
  Gets a single cart.

  Raises `Ecto.NoResultsError` if the Cart does not exist.

  ## Examples

      iex> get_cart!(123)
      %Cart{}

      iex> get_cart!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cart!(id), do: Repo.get!(Cart, id)

  @doc """
  Creates a cart.

  ## Examples

      iex> create_cart(%{field: value})
      {:ok, %Cart{}}

      iex> create_cart(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cart(attrs \\ %{}) do
    %Cart{}
    |> Cart.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cart.

  ## Examples

      iex> update_cart(cart, %{field: new_value})
      {:ok, %Cart{}}

      iex> update_cart(cart, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cart(%Cart{} = cart, attrs) do
    cart
    |> Cart.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cart.

  ## Examples

      iex> delete_cart(cart)
      {:ok, %Cart{}}

      iex> delete_cart(cart)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cart(%Cart{} = cart) do
    Repo.delete(cart)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cart changes.

  ## Examples

      iex> change_cart(cart)
      %Ecto.Changeset{data: %Cart{}}

  """
  def change_cart(%Cart{} = cart, attrs \\ %{}) do
    Cart.changeset(cart, attrs)
  end
end
