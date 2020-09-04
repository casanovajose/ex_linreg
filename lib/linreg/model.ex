defmodule Linreg.Model do
  defstruct m: 0.0, b: 0.0 # slope + intercept

  alias __MODULE__

  def new do
    %Model{}
  end

  def predict(%Model{m: m, b: b}, x) do
    b + m * x
  end

  def train(%Model{} = model, %Linreg.Data{points: points}, opts \\ []) do
    learning_rate = Keyword.get(opts, :learning_rate, 0.01)
    epochs = Keyword.get(opts, :epochs, 100)

    for _epoch <- 1..epochs, reduce: model do
      %Model{m: m, b: b} = model ->
         # mean error of m
        m_error =
          points
          |> Enum.map(fn {x, y} -> x* (predict(model, x) - y) end)
          |> Enum.sum()
          |> Kernel./(length(points))

        # mean error of b
        b_error =
          points
          |> Enum.map(fn {x, y} -> predict(model, x) - y end)
          |> Enum.sum()
          |> Kernel./(length(points))

          %Model{model | m: m - m_error * learning_rate, b: b - b_error * learning_rate}
    end
  end
end
