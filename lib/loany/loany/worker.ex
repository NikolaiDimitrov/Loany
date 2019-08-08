defmodule Loany.Loany.Worker do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def create_loan(loan_params) do
    GenServer.call(__MODULE__, {:create_loan, loan_params})
  end

  def get_loans() do
    GenServer.call(__MODULE__, :get_loans)
  end

  def handle_call({:create_loan, loan_params}, _from, state) do
    new_state = [loan_params | state]
    {:reply, :ok, new_state}
  end

  def handle_call(:get_loans, _from, state) do
    {:reply, state, state}
  end
end
