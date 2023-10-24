defmodule Takso.Bookingservices.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :pickup_address, :string
    field :dropoff_address, :string
    timestamps()

  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:pickup_address, :dropoff_address])
    |> validate_required([:pickup_address, :dropoff_address])
    |> validate_required(:pickup_address, :dropoff_address)

  end
end
