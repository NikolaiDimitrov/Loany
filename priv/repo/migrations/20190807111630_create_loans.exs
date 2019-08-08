defmodule Loany.Repo.Migrations.CreateLoans do
  use Ecto.Migration

  def change do
    create table(:loans) do
      add :amount, :integer
      add :applicant_names, :string
      add :phone_number, :string
      add :email, :string

      timestamps()
    end
  end
end
