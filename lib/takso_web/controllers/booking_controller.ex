defmodule TaksoWeb.BookingController do
  import Ecto.Query, only: [from: 2]
  alias Takso.{Repo,Sales.Taxi, Sales.Booking}
  use TaksoWeb, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
  # Same than before but handling the query GET to "/bookings" (":index").
  def index(conn, _params) do
    render conn, "index.html"
  end

  def create(conn, %{"booking" => booking_params}) do
    # Create changeset for the booking (to validate)
    changeset = Booking.changeset(%Booking{}, booking_params)
    if changeset.valid? do
      # Valid, query the database to retrieve the list of available taxis
      query = from t in Taxi, where: t.status == "available", select: t
      available_taxis = Repo.all(query)
      # If there are available taxis
      if length(available_taxis) > 0 do
        # Make association and try to insert the booking in the DB
        user = conn.assigns.current_user  # Retrieve the current user from the connection
        booking_assoc = Ecto.build_assoc(
          user,
          :bookings,
          Enum.map(booking_params, fn({key, value}) -> {String.to_atom(key), value} end)
        )
        case Repo.insert(booking_assoc) do
          {:ok, _booking} ->
            conn
              |> put_flash(:info, "Your taxi will arrive in 15 minutes.")
              |> redirect(to: ~p"/bookings")
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      else
        # Redirect informing there are no taxis
        conn
          |> put_flash(:error, "We are sorry, but there are no taxis available, try again later.")
          |> redirect(to: ~p"/bookings")
      end
    else
      # Invalid, report error
      #   Call to "Repo.insert/1" knowing it is going to fail
      #   only to add the error report in the changeset
      {:error, changeset} = Repo.insert(changeset)
      render(conn, "new.html", changeset: changeset)
    end
  end
end

  # def create(conn, _params) do
  #   query = from(t in Taxi, where: t.status == "available")
  #   available_taxis = Repo.all(query)
  #   if Enum.empty?(available_taxis) do
  #     conn
  #     |> put_flash(:info, "At present, there is no taxi available!")
  #     |> redirect(to: ~p"/bookings")
  #   else
  #     conn
  #     |> put_flash(:info, "Your taxi will arrive in 15 minutes.")
  #     |> redirect(to: ~p"/bookings")
  #   end
  # end

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
