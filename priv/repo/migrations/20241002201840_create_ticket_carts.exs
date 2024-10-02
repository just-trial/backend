defmodule JustTravel.Repo.Migrations.CreateTicketCarts do
  use Ecto.Migration

  def change do
    create table(:ticket_carts) do
      add :cart_id, references(:carts, on_delete: :delete_all)
      add :ticket_id, references(:tickets, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:ticket_carts, [:cart_id])
    create index(:ticket_carts, [:ticket_id])
  end
end
