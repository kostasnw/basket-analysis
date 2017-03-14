defmodule Data do
  alias NimbleCSV.RFC4180, as: CSV

  def load(src) do
    File.read!(src)
    |> parse
    |> filter
    |> normalize
  end

  def print(src) do
    load(src) |> print
  end

  defp parse(string) do
    CSV.parse_string(string)
  end

  defp filter(rows) do
    rows
    |> Enum.map(&Enum.drop(&1, -5))
    |> Enum.filter(fn(x) -> Enum.count(x, fn(x) -> x != "" end) == 5 end)
    |> Enum.drop(1)
  end

  defp normalize(rows) do
    Enum.map(rows, &parse_amounts(&1))
  end

  defp parse_amounts([name, transaction_id, revenue, uniq_purchases, quantity]) do
    [name, transaction_id, parse_to_float(revenue), parse_to_integer(uniq_purchases), parse_to_integer(quantity)]
  end

  defp parse_to_float(string) do
    string
    |> String.replace("€", "")
    |> String.replace(",", "")
    |> String.to_float
  end

  defp parse_to_integer(string) do
    string
    |> String.replace(",", "")
    |> String.to_integer
  end
end