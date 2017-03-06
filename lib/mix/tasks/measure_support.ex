defmodule Mix.Tasks.MeasureSupport do
  use Mix.Task

  @shortdoc "Measure Support for items"
  def run(_) do
    BasketAnalysis.measure_support
  end
end