defmodule TaksoWeb.BookingController do
  import Ecto.Query, only: [from: 2]
  alias Takso.{Repo,Sales.Taxi}
  use TaksoWeb, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
  # Same than before but handling the query GET to "/bookings" (":index").
  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, _params) do
    query = from(t in Taxi, where: t.status == "available")
    available_taxis = Repo.all(query)
    if Enum.empty?(available_taxis) do
      conn
      |> put_flash(:info, "At present, there is no taxi available!")
      |> redirect(to: ~p"/bookings")
    else
      conn
      |> put_flash(:info, "Your taxi will arrive in 15 minutes.")
      |> redirect(to: ~p"/bookings")
    end
  end
end
  # def create(conn, _params) do
  #   query = from(t in Taxi, where: t.status == "available")
  #   available_taxis = Repo.all(query)
  #   available_taxis_count = length(available_taxis)
  #   if available_taxis_count = 0 do
  #     flash_message = "At present, there are no taxis available!"
  #     conn
  #       |> put_flash(:info, flash_message)
  #       |> redirect(to: Routes.booking_path(conn, :index))

  #   else
  #     flash_message = "There are #{available_taxis_count} available taxis. Your taxi will arrive in 15 minutes."
  #     conn
  #       |> put_flash(:info, flash_message)
  #       |> redirect(to: Routes.booking_path(conn, :index))


  #   end
  # end
