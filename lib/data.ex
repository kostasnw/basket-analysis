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
    |> Enum.drop(1)
  end

  defp normalize(rows) do
    Enum.map(rows, &parse_amounts(&1))
  end

  defp parse_amounts([name, transaction_id]) do
    [name, transaction_id |> String.replace("\r", "")]
  end

end