defmodule LinregWeb.RegressionLive do
  use LinregWeb, :live_view
  alias Linreg.{Data, Math, Model}

  @impl true
  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(model: Model.new())
      |> assign(data: Data.new())
      |> assign(start_y: 0)
      |> assign(end_y: 0)

    IO.inspect(params, label: "params mount")
    {:ok, socket}
  end

  @impl true
  def handle_event("add_point", params, socket) do
    {:noreply, add_point(params, socket)}
  end

  defp add_point(%{"offsetX" => x, "offsetY" => y}, socket) do
    data =
      socket.assigns
      |> Map.get(:data)
      |> Data.add_point(map(x, 0, 800, 0, 1), map(y, 0, 800, 0, 1))

      IO.inspect(data, label: "mapped points")
      #assign(socket, data: data)

      socket
      |> assign(data: data)
      |> learn()
      |> update_prediction()
  end

  defp learn(%{assigns: %{data: data, model: model}} = socket) do
    if length(data.points) >= 2 do
      model = Model.train(model, data, learning_rate: 0.1, epochs: 500)
      assign(socket, model: model)
    else
      socket
    end
  end

  defp update_prediction(%{assigns: %{model: model}} = socket) do
    socket
    |> assign(start_y: Model.predict(model, 0))
    |> assign(end_y: Model.predict(model, 1))
  end

  end
