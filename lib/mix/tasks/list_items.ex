defmodule Mix.Tasks.ListItems do
  use Mix.Task

  @shortdoc "List items from csv file"
  def run(_) do
    BasketAnalysis.list_items
  end
end