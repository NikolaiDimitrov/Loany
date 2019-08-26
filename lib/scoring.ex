defmodule Loany.Scoring do
  alias Loany.LoanServer.Worker, as: Loany
  @base 100

  def evaluate_loan_application(%{"amount" => amount}) do
    amount =
      if(amount != "") do
        String.to_integer(amount)
      else
        0
      end

    status =
      if(lower_amount?(amount)) do
        :approved
      else
        :rejected
      end

    score =
      if is_prime?(amount) do
        9.99
      else
        give_interest_rate()
      end

    {status, score}
  end

  defp lower_amount?(loan_amount) do
    max_amount = Loany.get_max_loan_amount()

    if(loan_amount > max_amount) do
      Loany.create_loan(loan_amount)
      true
    else
      false
    end
  end

  defp give_interest_rate() do
    significand = Enum.random(400..1200)
    significand / @base
  end

  defp is_prime?(n) when n in [2, 3], do: true

  defp is_prime?(n) do
    floored_sqrt =
      :math.sqrt(n)
      |> Float.floor()
      |> round

    !Enum.any?(2..floored_sqrt, &(rem(n, &1) == 0))
  end
end
