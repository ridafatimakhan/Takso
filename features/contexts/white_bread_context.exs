defmodule WhiteBreadContext do
  alias Takso.{Repo,Sales.Taxi}
  use WhiteBread.Context
  use Hound.Helpers
  feature_starting_state fn  ->
    Application.ensure_all_started(:hound)
    %{}
  end
  scenario_starting_state fn state ->
    Hound.start_session
    Ecto.Adapters.SQL.Sandbox.checkout(Takso.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Takso.Repo, {:shared, self()})
    %{}
  end

  scenario_finalize fn _status, _state ->
    Ecto.Adapters.SQL.Sandbox.checkin(Takso.Repo)
    # Hound.end_session
  end

  given_ ~r/^the following taxis are on duty$/, fn state, %{table_data: table} ->
    table
    |> Enum.map(fn taxi -> Taxi.changeset(%Taxi{}, taxi) end)
    |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
    {:ok, state}
  end

  and_ ~r/^I want to go from "(?<pickup_address>[^"]+)" to "(?<dropoff_address>[^"]+)"$/,
  fn state, %{pickup_address: pickup_address, dropoff_address: dropoff_address} ->
    # Adding the pickup_address and dropoff_address variables to the state variable.
    # As you can see, the state is being passed from step to step, so we will access these
    # two values in future steps to set the in the web forms.
    {:ok, state |> Map.put(:pickup_address, pickup_address) |> Map.put(:dropoff_address, dropoff_address)}
  end

  and_ ~r/^I open STRS' web page$/, fn state ->
    # Redirect to the new booking page
    navigate_to "/bookings/new"
    {:ok, state}
  end

  and_ ~r/^I enter the booking information$/, fn state ->
    # Enter booking information (taking it from the state)
    fill_field({:id, "pickup_address"}, state[:pickup_address])
    fill_field({:id, "dropoff_address"}, state[:dropoff_address])
    {:ok, state}
  end

  when_ ~r/^I summit the booking request$/, fn state ->
    # Submit button of the form to make the booking
    click({:id, "submit_button"})
    {:ok, state}
  end

  # then_ ~r/^I should receive a confirmation message$/, fn state ->
  #   # Check that we get the expected message in the page
  #   assert visible_in_page? ~r/Your taxi will arrive in \d+ minutes/
  #   {:ok, state}
  # end

  then_ ~r/^I should receive a confirmation message "(?<argument_one>[^"]+)"$/,
   fn state, %{argument_one: _argument_one} ->
   {:ok, state}
end

  then_ ~r/^I should receive a rejection message$/, fn state ->
    {:ok, state}
  end

  then_ ~r/^I should receive an error saying "(?<argument_one>[^"]+)"$/,
fn state, %{argument_one: _argument_one} ->
  {:ok, state}
end

end
