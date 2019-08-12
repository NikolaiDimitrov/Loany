defmodule Loany.LoanServer.Worker do
  use GenServer

  alias Loany.Loans

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    state = Loans.get_max_amount()
    state = if is_nil(state), do: 0, else: state
    {:ok, state}
  end

  def create_loan(loan_params) do
    GenServer.call(__MODULE__, {:create_loan, loan_params})
  end

  def get_max_loan_amount() do
    GenServer.call(__MODULE__, :get_loans)
  end

  def handle_call({:create_loan, loan_params}, _from, state) do
    if(loan_params > state) do
      new_state = loan_params
      {:reply, :ok, new_state}
    else
      {:reply, :ok, state}
    end
  end

  def handle_call(:get_loans, _from, state) do
    {:reply, state, state}
  end
end
