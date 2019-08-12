defmodule Loany.Repo.Migrations.AddColumn do
  use Ecto.Migration

  def change do
    alter table(:loans) do
      add :loan_status, :string
      add :loan_score, :string
    end
  end
end
