defmodule StoreWeb.MerchantControllerTest do
  use StoreWeb.ConnCase

  alias Store.Accounts

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:merchant) do
    {:ok, merchant} = Accounts.create_merchant(@create_attrs)
    merchant
  end

  describe "index" do
    test "lists all merchants", %{conn: conn} do
      conn = get conn, merchant_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Merchants"
    end
  end

  describe "new merchant" do
    test "renders form", %{conn: conn} do
      conn = get conn, merchant_path(conn, :new)
      assert html_response(conn, 200) =~ "New Merchant"
    end
  end

  describe "create merchant" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, merchant_path(conn, :create), merchant: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == merchant_path(conn, :show, id)

      conn = get conn, merchant_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Merchant"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, merchant_path(conn, :create), merchant: @invalid_attrs
      assert html_response(conn, 200) =~ "New Merchant"
    end
  end

  describe "edit merchant" do
    setup [:create_merchant]

    test "renders form for editing chosen merchant", %{conn: conn, merchant: merchant} do
      conn = get conn, merchant_path(conn, :edit, merchant)
      assert html_response(conn, 200) =~ "Edit Merchant"
    end
  end

  describe "update merchant" do
    setup [:create_merchant]

    test "redirects when data is valid", %{conn: conn, merchant: merchant} do
      conn = put conn, merchant_path(conn, :update, merchant), merchant: @update_attrs
      assert redirected_to(conn) == merchant_path(conn, :show, merchant)

      conn = get conn, merchant_path(conn, :show, merchant)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, merchant: merchant} do
      conn = put conn, merchant_path(conn, :update, merchant), merchant: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Merchant"
    end
  end

  describe "delete merchant" do
    setup [:create_merchant]

    test "deletes chosen merchant", %{conn: conn, merchant: merchant} do
      conn = delete conn, merchant_path(conn, :delete, merchant)
      assert redirected_to(conn) == merchant_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, merchant_path(conn, :show, merchant)
      end
    end
  end

  defp create_merchant(_) do
    merchant = fixture(:merchant)
    {:ok, merchant: merchant}
  end
end
