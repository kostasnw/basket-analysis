defmodule Print do
  alias NimbleCSV.RFC4180, as: CSV

  def sets(sets) do
    IO.puts "Products\tSupport\tConfidence\tLift"
    sets |> Enum.each(&sets_output(&1)) |> IO.puts
  end

  defp sets_output({[first_product, second_product], %{support: support, confidence: confidence, lift: lift}}) do
    IO.puts "#{first_product} -> #{second_product}\t#{support}\t#{confidence}\t#{lift}"
  end

  def to_csv(sets, target \\ "output.csv") do
    file = File.open!(target, [:write, :utf8])
    IO.write file, CSV.dump_to_iodata([~w(Product Support Confidence Lift) | Enum.map(sets, &sets_to_csv(&1))])
  end

  defp sets_to_csv({[first_product, second_product], %{support: support, confidence: confidence, lift: lift}}) do
    ["#{first_product} -> #{second_product}", "#{:erlang.float_to_binary(support*100, decimals: 4)}%", "#{:erlang.float_to_binary(confidence*100, decimals: 1)}%", lift]
  end

end