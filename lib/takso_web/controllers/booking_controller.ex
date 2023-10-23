defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end
  # Same than before but handling the query GET to "/bookings" (":index").
  def index(conn, _params) do
    render conn, "index.html"
  end

end
