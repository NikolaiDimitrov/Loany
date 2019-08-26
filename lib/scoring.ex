defmodule Loany.Scoring do
  alias Loany.LoanServer.MaxLoan

  @prime_amount_interest_rate 9.99
  @base 100

  def evaluate_loan_application(%{"amount" => amount}) do
    amount =
      if(amount != "") do
        String.to_integer(amount)
      else
        0
      end

    max_amount = MaxLoan.get()

    status =
      if(amount > max_amount) do
        MaxLoan.update(amount)

        :approved
      else
        :rejected
      end

    score =
      if is_prime?(amount) do
        @prime_amount_interest_rate
      else
        generate_interest_rate()
      end

    {status, score}
  end

  defp generate_interest_rate(), do: Enum.random(400..1200) / @base

  defp is_prime?(n) when n in [2, 3], do: true

  defp is_prime?(n) do
    floored_sqrt =
      :math.sqrt(n)
      |> Float.floor()
      |> round

    !Enum.any?(2..floored_sqrt, &(rem(n, &1) == 0))
  end
end
