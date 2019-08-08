defmodule Loany.Loans.Loan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "loans" do
    field :amount, :integer
    field :applicant_names, :string
    field :email, :string
    field :phone_number, :string
    field :loan_status, :string

    timestamps()
  end

  @doc false
  def changeset(loan, attrs) do
    loan
    |> cast(attrs, [:amount, :applicant_names, :phone_number, :email, :loan_status])
    |> validate_required([:amount, :applicant_names, :phone_number, :email])
    |> validate_number(:amount, greater_than: 0)
    |> validate_format(:email, ~r/@/)
  end
end
