defmodule TaksoWeb.UserController do
  # import TaksoWeb.Router.Helpers, only: [user_path: 3]
  use TaksoWeb, :controller

  alias Takso.{Repo, Accounts.User}

  def index(conn, _params) do
    users = Repo.all(User)
    render conn, "index.html", users: users
  end
  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end
  # def create(conn, %{"user" => user_params}) do
  #   changeset = User.changeset(%User{}, user_params)

  #   Repo.insert(changeset)
  #   redirect(conn, to: ~p"/users")
  # end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
          |> put_flash(:info, "User created successfully.")
          |> redirect(to: ~p"/users")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, %{})
    render(conn, "edit.html", user: user, changeset: changeset)
  end
  # def update(conn, %{"id" => id, "user" => user_params}) do
  #   user = Repo.get!(User, id)
  #   changeset = User.changeset(user, user_params)

  #   Repo.update(changeset)
  #   redirect(conn, to: ~p"/users")
  # end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)
    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
          |> put_flash(:info, "User updated successfully")
          |> redirect(to: ~p"/users" )
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: ~p"/users")
  end
end

  # def validate_age(changeset) do
  #   validate_number(changeset, :age, greater_than_or_equal_to: 0)
  # end
