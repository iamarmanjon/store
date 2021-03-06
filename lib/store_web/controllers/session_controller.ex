defmodule StoreWeb.SessionController do
  use StoreWeb, :controller
  alias Store.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"merchant" => %{"email" => email}}) do
    case Accounts.authenticate_by_email_password(email, "nopassword") do
      {:ok, merchant} ->
        conn
        |> put_flash(:info, "Welcome!")
        |> put_session(:merchant_id, merchant.id)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password combination")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: session_path(conn, :new))
  end
end
