defmodule LinregWeb.RegressionLive do
  use LinregWeb, :live_view
  alias Linreg.{Data, Math, Model}

  @impl true
  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(model: Model.new())
      |> assign(data: Data.new())
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
      assign(socket, data: data)
    end

  end
