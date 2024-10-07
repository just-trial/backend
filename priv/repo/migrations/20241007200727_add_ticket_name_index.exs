defmodule JustTravel.Repo.Migrations.AddTicketNameIndex do
  use Ecto.Migration

  def up do
    execute("CREATE INDEX idx_title_lower ON tickets (LOWER(name));")
  end

  def down do
    execute("DROP INDEX idx_title_lower;")
  end
end
