defmodule Scandoc.CustomersTest do
  use Scandoc.DataCase

  alias Scandoc.Customers

  describe "phones" do
    alias Scandoc.Customers.Phone

    @valid_attrs %{google_account: "some google_account", google_ref_token: "some google_ref_token", google_token: "some google_token", note: "some note", phonenum: "some phonenum", provider_token: "some provider_token", provider_unique_id: "some provider_unique_id", provider_url: "some provider_url", sendertype: "some sendertype", title: "some title", user_id: "some user_id"}
    @update_attrs %{google_account: "some updated google_account", google_ref_token: "some updated google_ref_token", google_token: "some updated google_token", note: "some updated note", phonenum: "some updated phonenum", provider_token: "some updated provider_token", provider_unique_id: "some updated provider_unique_id", provider_url: "some updated provider_url", sendertype: "some updated sendertype", title: "some updated title", user_id: "some updated user_id"}
    @invalid_attrs %{google_account: nil, google_ref_token: nil, google_token: nil, note: nil, phonenum: nil, provider_token: nil, provider_unique_id: nil, provider_url: nil, sendertype: nil, title: nil, user_id: nil}

    def phone_fixture(attrs \\ %{}) do
      {:ok, phone} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Customers.create_phone()

      phone
    end

    test "list_phones/0 returns all phones" do
      phone = phone_fixture()
      assert Customers.list_phones() == [phone]
    end

    test "get_phone!/1 returns the phone with given id" do
      phone = phone_fixture()
      assert Customers.get_phone!(phone.id) == phone
    end

    test "create_phone/1 with valid data creates a phone" do
      assert {:ok, %Phone{} = phone} = Customers.create_phone(@valid_attrs)
      assert phone.google_account == "some google_account"
      assert phone.google_ref_token == "some google_ref_token"
      assert phone.google_token == "some google_token"
      assert phone.note == "some note"
      assert phone.phonenum == "some phonenum"
      assert phone.provider_token == "some provider_token"
      assert phone.provider_unique_id == "some provider_unique_id"
      assert phone.provider_url == "some provider_url"
      assert phone.sendertype == "some sendertype"
      assert phone.title == "some title"
      assert phone.user_id == "some user_id"
    end

    test "create_phone/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_phone(@invalid_attrs)
    end

    test "update_phone/2 with valid data updates the phone" do
      phone = phone_fixture()
      assert {:ok, %Phone{} = phone} = Customers.update_phone(phone, @update_attrs)
      assert phone.google_account == "some updated google_account"
      assert phone.google_ref_token == "some updated google_ref_token"
      assert phone.google_token == "some updated google_token"
      assert phone.note == "some updated note"
      assert phone.phonenum == "some updated phonenum"
      assert phone.provider_token == "some updated provider_token"
      assert phone.provider_unique_id == "some updated provider_unique_id"
      assert phone.provider_url == "some updated provider_url"
      assert phone.sendertype == "some updated sendertype"
      assert phone.title == "some updated title"
      assert phone.user_id == "some updated user_id"
    end

    test "update_phone/2 with invalid data returns error changeset" do
      phone = phone_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_phone(phone, @invalid_attrs)
      assert phone == Customers.get_phone!(phone.id)
    end

    test "delete_phone/1 deletes the phone" do
      phone = phone_fixture()
      assert {:ok, %Phone{}} = Customers.delete_phone(phone)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_phone!(phone.id) end
    end

    test "change_phone/1 returns a phone changeset" do
      phone = phone_fixture()
      assert %Ecto.Changeset{} = Customers.change_phone(phone)
    end
  end

  describe "users" do
    alias Scandoc.Customers.Customer

    @valid_attrs %{email: "some email", first_name: "some first_name", hashed_password: "some hashed_password", is_freezed: true, last_name: "some last_name", role: "some role"}
    @update_attrs %{email: "some updated email", first_name: "some updated first_name", hashed_password: "some updated hashed_password", is_freezed: false, last_name: "some updated last_name", role: "some updated role"}
    @invalid_attrs %{email: nil, first_name: nil, hashed_password: nil, is_freezed: nil, last_name: nil, role: nil}

    def customer_fixture(attrs \\ %{}) do
      {:ok, customer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Customers.create_customer()

      customer
    end

    test "list_users/0 returns all users" do
      customer = customer_fixture()
      assert Customers.list_users() == [customer]
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer!(customer.id) == customer
    end

    test "create_customer/1 with valid data creates a customer" do
      assert {:ok, %Customer{} = customer} = Customers.create_customer(@valid_attrs)
      assert customer.email == "some email"
      assert customer.first_name == "some first_name"
      assert customer.hashed_password == "some hashed_password"
      assert customer.is_freezed == true
      assert customer.last_name == "some last_name"
      assert customer.role == "some role"
    end

    test "create_customer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Customers.create_customer(@invalid_attrs)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{} = customer} = Customers.update_customer(customer, @update_attrs)
      assert customer.email == "some updated email"
      assert customer.first_name == "some updated first_name"
      assert customer.hashed_password == "some updated hashed_password"
      assert customer.is_freezed == false
      assert customer.last_name == "some updated last_name"
      assert customer.role == "some updated role"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(customer, @invalid_attrs)
      assert customer == Customers.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Customers.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer(customer)
    end
  end
end
