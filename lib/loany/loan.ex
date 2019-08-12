defmodule Loany.Loan do
  use Ecto.Schema
  import Ecto.Changeset

  schema "loans" do
    field :amount, :integer
    field :applicant_names, :string
    field :email, :string
    field :phone_number, :string
    field :loan_status, :string
    field :loan_score, :string

    timestamps()
  end

  @doc false
  def changeset(loan, attrs) do
    loan
    |> cast(attrs, [:amount, :applicant_names, :phone_number, :email, :loan_status, :loan_score])
    |> validate_required([:amount, :applicant_names, :phone_number, :email])
    |> validate_number(:amount, greater_than: 0)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:phone_number, min: 7, max: 15, message: "Phone must be 7-15 characters")
    |> validate_phone()
  end

  def validate_phone(%Ecto.Changeset{} = changeset) do
    value = Map.get(changeset.changes, :phone_number)

    if value == nil do
      add_error(changeset, :phone_number, "Phone number can not be empty")
    else
      if String.match?(value, ~r/^[+]?[0-9]{7,14}$/) do
        changeset
      else
        add_error(changeset, :phone_number, "Invalid phone number")
      end
    end
  end
end
