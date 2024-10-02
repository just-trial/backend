defmodule JustTravel.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :name, :string
      add :city, :string
      add :price, :decimal
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create index(:tickets, [:city])
  end
end
