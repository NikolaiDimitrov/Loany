defmodule LoanyWeb.LoanController do
  use LoanyWeb, :controller

  alias Loany.{Loans, Loan, Scoring}

  def index(conn, _params) do
    changeset = Loans.change_loan(%Loan{})
    action = Routes.loan_path(conn, :create)

    render(conn, "index.html", changeset: changeset, action: action)
  end

  def new(conn, _params) do
    loans = Loans.list_loans()

    render(conn, "new.html", loans: loans)
  end

  def create(conn, %{"loan" => loan_params}) do
    {loan_status, loan_value} = Scoring.evaluate_loan_application(loan_params)

    IO.inspect(loan_params, limit: :infinity)

    loan_params =
      loan_params
      |> Map.put("loan_status", Atom.to_string(loan_status))
      |> Map.put("loan_score", loan_value)
      |> Map.update!("phone_number", fn phone_number ->
        String.replace(phone_number, ~r/\s/, "")
      end)

    IO.inspect(loan_params, limit: :infinity)

    case Loans.create_loan(loan_params) do
      {:ok, loan} ->
        if(loan_status == :rejected) do
          redirect(conn, to: Routes.loan_path(conn, :edit, :ok))
        else
          redirect(conn, to: Routes.loan_path(conn, :show, loan))
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        action = Routes.loan_path(conn, :create)

        render(conn, "index.html", changeset: changeset, action: action)
    end
  end

  def show(conn, %{"id" => id}) do
    loan = Loans.get_loan!(id)

    render(conn, "show.html", loan: loan)
  end

  def edit(conn, _params) do
    render(conn, "edit.html")
  end
end
