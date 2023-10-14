defmodule Takso.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string
    field :age, :integer

    timestamps()
  end

  def validate_age(changeset) do
    age = get_field(changeset, :age)

    case age do
      nil -> add_error(changeset, :age, "Age is required.")
      _ when is_integer(age) and age > 0 -> changeset
      _ -> add_error(changeset, :age, "Age must be greater than 0.")
    end
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :password, :age])
    |> validate_required([:name, :username, :password, :age])
    |> validate_age()
  end
end
  # def Users.update(%User{} = user, user_params) do
  #   user
  #   |> User.changeset(params)
  #   |> Repo.update()
  # end


#   def changeset(struct, params \\ %{}) do
#     struct
#     |> cast(params, [:name, :username, :password])
#     |> validate_required([:name, :username, :password])
#   end
# end
#  def changeset(struct, params \\ %{} ) do
#   struct
#    |> cast(params, [:name, :username, :password, :age])
#    |> validate_required([:name, :username, :password, :age])
#    |> validate_age()
#   end
