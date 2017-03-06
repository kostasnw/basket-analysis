defmodule Data do
  alias NimbleCSV.RFC4180, as: CSV

  def load do
    File.read!("lib/items.csv")
    |> parse
    |> filter
    |> normalize
  end

  def print do
    load |> print
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

  defp print(rows) do
    IO.puts "\nProducts:"
    Enum.each(rows, &print_to_console(&1))
  end

  defp print_to_console([name, transaction_id, revenue, uniq_purchases, quantity]) do
    IO.puts "#{name} - #{transaction_id}: €#{:erlang.float_to_binary(revenue, decimals: 2)}, quantity: #{quantity}, unique purchases: #{uniq_purchases}"
  end
end