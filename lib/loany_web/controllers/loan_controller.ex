defmodule LoanyWeb.LoanController do
  use LoanyWeb, :controller

  alias Loany.Loans
  alias Loany.Loan
  alias Loany.Scoring

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

    loan_params =
      loan_params
      |> Map.put("loan_status", Atom.to_string(loan_status))
      |> Map.put("loan_score", loan_value)

    case Loans.create_loan(loan_params) do
      {:ok, loan} ->
        if(loan_status == :rejected) do
          redirect(conn, to: Routes.loan_path(conn, :edit, loan_value))
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

  def edit(conn, %{"id" => rate}) do
    render(conn, "edit.html", rate: rate)
  end
end
