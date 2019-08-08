defmodule LoanyWeb.LoanController do
  use LoanyWeb, :controller

  alias Loany.Loans
  alias Loany.Loans.Loan
  alias Loany.Scoring.Scoring
  alias Loany.Loany.Worker, as: Loany

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
    loan_value = Scoring.value_loan(loan_params)
    loan_params = Map.put(loan_params, "loan_status", loan_value)

    case Loans.create_loan(loan_params) do
      {:ok, loan} ->
        if(loan_value == "REJ") do
          conn = put_flash(conn, :info, "Try again!")
          redirect(conn, to: Routes.loan_path(conn, :index))
        else
          Loany.create_loan(loan_params)
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
    changeset = Loans.change_loan(%Loan{})
    action = Routes.loan_path(conn, :index)
    render(conn, "edit.html", changeset: changeset, action: action, conn: conn)
  end
end
