defmodule Loany.Scoring.Scoring do
  alias Loany.Loany.Worker, as: Loany

  def value_loan(loan) do
    %{"amount" => amount} = loan

    amount =
      if(amount != "") do
        String.to_integer(amount)
      else
        0
      end

    if(lower_amount?(amount)) do
      if is_prime?(amount), do: "9.99%", else: give_interest_rate()
    else
      "REJ"
    end
  end

  defp lower_amount?(loan_amount) do
    previous_applicants = Loany.get_loans()

    Enum.reduce_while(previous_applicants, true, fn applicant, _acc ->
      %{"amount" => amount} = applicant
      amount = String.to_integer(amount)
      if amount < loan_amount, do: {:cont, true}, else: {:halt, false}
    end)
  end

  defp give_interest_rate() do
    rate = Enum.random(4..12)
    Integer.to_string(rate) <> "%"
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
