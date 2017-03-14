defmodule BasketAnalysis do

  def measure_support do
    main
  end

  def main(args \\ []) do
    {opts, _, _} = OptionParser.parse(args,
          switches: [src: :string, support: :float],
          aliases: [S: :src, s: :support]
          )
    items = opts[:src] |> Data.load
    baskets = get_baskets items
    get_sets(
      %{},
      baskets |> Enum.into([]),
      baskets,
      get_support(
        %{},
        items |> Enum.map(&get_product(&1)) |> Enum.uniq,
        baskets
      )
    )
    |> Print.to_csv
  end

  defp get_sets(sets, [{_, items} | t], baskets, product_support) do
    sets |> get_sets_from_basket(Enum.chunk(items, 2, 1), baskets, product_support) |> get_sets(t, baskets, product_support)
  end

  defp get_sets(sets, [], _, _) do
    sets
  end

  defp get_sets_from_basket(sets, [h | t], baskets, product_support) do
    Map.put_new(sets, h, calculate_measures(h, baskets, product_support)) |> get_sets_from_basket(t, baskets, product_support)
  end

  defp get_sets_from_basket(sets, [], _, _) do
    sets
  end

  defp get_baskets(items) do
    items |> Enum.group_by(&get_transaction_id(&1), &get_product(&1))
  end

  defp get_product([name, _, _, _, _]) do
    name
  end

  defp get_transaction_id([_, transaction_id, _, _, _]) do
    transaction_id
  end

  defp get_support(support, [h | t], baskets) do
    Map.put(support, h, calculate_support(h, baskets)) |> get_support(t, baskets)
  end

  defp get_support(support, [], _) do
    support
  end

  defp calculate_support(measures, products, baskets) do
    Map.put(measures, :support, count_product_occurrences(products, baskets)/Enum.count(baskets))
  end

  defp calculate_support(product, baskets) do
    count_product_occurrences(product, baskets)/Enum.count(baskets)
  end

  defp calculate_measures(products, baskets, product_support) do
    %{}
    |> calculate_support(products, baskets)
    |> calculate_confidence(products, product_support)
    |> calculate_lift(products, product_support)
  end

  defp count_product_occurrences([first_product, second_product], baskets) do
    Enum.filter(baskets, fn({_,v}) ->
      v |> Enum.any?(fn(x) ->
        x == first_product
      end) &&
      v |> Enum.any?(fn(x) ->
        x == second_product
      end)
    end) |> Enum.count
  end

  defp count_product_occurrences(product, baskets) do
    Enum.filter(baskets, fn({_,v}) ->
      v |> Enum.any?(fn(x) ->
        x == product
      end)
    end) |> Enum.count
  end

  defp calculate_confidence(measures, [first_product, _], product_support) do
    Map.put(
      measures,
      :confidence,
      measures[:support]/product_support[first_product]
    )
  end

  defp calculate_lift(measures, [first_product, second_product], product_support) do
    Map.put(
      measures,
      :lift,
      measures[:support]/(product_support[first_product] * product_support[second_product])
    )
  end

end