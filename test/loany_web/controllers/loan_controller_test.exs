defmodule LoanyWeb.LoanControllerTest do
  use LoanyWeb.ConnCase

  alias Loany.Loans

  @create_attrs %{
    amount: 42,
    applicant_names: "some applicant_names",
    email: "some email",
    phone_number: "some phone_number"
  }
  @update_attrs %{
    amount: 43,
    applicant_names: "some updated applicant_names",
    email: "some updated email",
    phone_number: "some updated phone_number"
  }
  @invalid_attrs %{amount: nil, applicant_names: nil, email: nil, phone_number: nil}

  def fixture(:loan) do
    {:ok, loan} = Loans.create_loan(@create_attrs)
    loan
  end

  describe "index" do
    test "lists all loans", %{conn: conn} do
      conn = get(conn, Routes.loan_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Loans"
    end
  end

  describe "new loan" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.loan_path(conn, :new))
      assert html_response(conn, 200) =~ "New Loan"
    end
  end

  describe "create loan" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.loan_path(conn, :create), loan: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.loan_path(conn, :show, id)

      conn = get(conn, Routes.loan_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Loan"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.loan_path(conn, :create), loan: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Loan"
    end
  end

  describe "edit loan" do
    setup [:create_loan]

    test "renders form for editing chosen loan", %{conn: conn, loan: loan} do
      conn = get(conn, Routes.loan_path(conn, :edit, loan))
      assert html_response(conn, 200) =~ "Edit Loan"
    end
  end

  describe "update loan" do
    setup [:create_loan]

    test "redirects when data is valid", %{conn: conn, loan: loan} do
      conn = put(conn, Routes.loan_path(conn, :update, loan), loan: @update_attrs)
      assert redirected_to(conn) == Routes.loan_path(conn, :show, loan)

      conn = get(conn, Routes.loan_path(conn, :show, loan))
      assert html_response(conn, 200) =~ "some updated applicant_names"
    end

    test "renders errors when data is invalid", %{conn: conn, loan: loan} do
      conn = put(conn, Routes.loan_path(conn, :update, loan), loan: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Loan"
    end
  end

  describe "delete loan" do
    setup [:create_loan]

    test "deletes chosen loan", %{conn: conn, loan: loan} do
      conn = delete(conn, Routes.loan_path(conn, :delete, loan))
      assert redirected_to(conn) == Routes.loan_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.loan_path(conn, :show, loan))
      end
    end
  end

  defp create_loan(_) do
    loan = fixture(:loan)
    {:ok, loan: loan}
  end
end
