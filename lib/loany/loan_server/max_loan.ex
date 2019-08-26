defmodule Loany.LoanServer.MaxLoan do
  use Agent

  alias Loany.Loans

  def start_link(_), do: Agent.start_link(fn -> Loans.get_max_amount() end, name: __MODULE__)

  def get(), do: Agent.get(__MODULE__, & &1)

  def update(new_loan) do
    if(new_loan > get()) do
      Agent.update(__MODULE__, fn _ -> new_loan end)
    else
      :ok
    end
  end
end
