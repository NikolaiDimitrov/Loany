defmodule Loany.LoansTest do
  use Loany.DataCase

  alias Loany.Loans

  describe "loans" do
    alias Loany.Loans.Loan

    @valid_attrs %{
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

    def loan_fixture(attrs \\ %{}) do
      {:ok, loan} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loans.create_loan()

      loan
    end

    test "list_loans/0 returns all loans" do
      loan = loan_fixture()
      assert Loans.list_loans() == [loan]
    end

    test "get_loan!/1 returns the loan with given id" do
      loan = loan_fixture()
      assert Loans.get_loan!(loan.id) == loan
    end

    test "create_loan/1 with valid data creates a loan" do
      assert {:ok, %Loan{} = loan} = Loans.create_loan(@valid_attrs)
      assert loan.amount == 42
      assert loan.applicant_names == "some applicant_names"
      assert loan.email == "some email"
      assert loan.phone_number == "some phone_number"
    end

    test "create_loan/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loans.create_loan(@invalid_attrs)
    end

    test "update_loan/2 with valid data updates the loan" do
      loan = loan_fixture()
      assert {:ok, %Loan{} = loan} = Loans.update_loan(loan, @update_attrs)
      assert loan.amount == 43
      assert loan.applicant_names == "some updated applicant_names"
      assert loan.email == "some updated email"
      assert loan.phone_number == "some updated phone_number"
    end

    test "update_loan/2 with invalid data returns error changeset" do
      loan = loan_fixture()
      assert {:error, %Ecto.Changeset{}} = Loans.update_loan(loan, @invalid_attrs)
      assert loan == Loans.get_loan!(loan.id)
    end

    test "delete_loan/1 deletes the loan" do
      loan = loan_fixture()
      assert {:ok, %Loan{}} = Loans.delete_loan(loan)
      assert_raise Ecto.NoResultsError, fn -> Loans.get_loan!(loan.id) end
    end

    test "change_loan/1 returns a loan changeset" do
      loan = loan_fixture()
      assert %Ecto.Changeset{} = Loans.change_loan(loan)
    end
  end
end
