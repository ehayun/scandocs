defmodule Scandoc.VendorsTest do
  use Scandoc.DataCase

  alias Scandoc.Vendors

  describe "vendors" do
    alias Scandoc.Vendors.Vendor

    @valid_attrs %{address: "some address", contact_name: "some contact_name", phone_number: "some phone_number", vendor_name: "some vendor_name", vendor_site: "some vendor_site"}
    @update_attrs %{address: "some updated address", contact_name: "some updated contact_name", phone_number: "some updated phone_number", vendor_name: "some updated vendor_name", vendor_site: "some updated vendor_site"}
    @invalid_attrs %{address: nil, contact_name: nil, phone_number: nil, vendor_name: nil, vendor_site: nil}

    def vendor_fixture(attrs \\ %{}) do
      {:ok, vendor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Vendors.create_vendor()

      vendor
    end

    test "list_vendors/0 returns all vendors" do
      vendor = vendor_fixture()
      assert Vendors.list_vendors() == [vendor]
    end

    test "get_vendor!/1 returns the vendor with given id" do
      vendor = vendor_fixture()
      assert Vendors.get_vendor!(vendor.id) == vendor
    end

    test "create_vendor/1 with valid data creates a vendor" do
      assert {:ok, %Vendor{} = vendor} = Vendors.create_vendor(@valid_attrs)
      assert vendor.address == "some address"
      assert vendor.contact_name == "some contact_name"
      assert vendor.phone_number == "some phone_number"
      assert vendor.vendor_name == "some vendor_name"
      assert vendor.vendor_site == "some vendor_site"
    end

    test "create_vendor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vendors.create_vendor(@invalid_attrs)
    end

    test "update_vendor/2 with valid data updates the vendor" do
      vendor = vendor_fixture()
      assert {:ok, %Vendor{} = vendor} = Vendors.update_vendor(vendor, @update_attrs)
      assert vendor.address == "some updated address"
      assert vendor.contact_name == "some updated contact_name"
      assert vendor.phone_number == "some updated phone_number"
      assert vendor.vendor_name == "some updated vendor_name"
      assert vendor.vendor_site == "some updated vendor_site"
    end

    test "update_vendor/2 with invalid data returns error changeset" do
      vendor = vendor_fixture()
      assert {:error, %Ecto.Changeset{}} = Vendors.update_vendor(vendor, @invalid_attrs)
      assert vendor == Vendors.get_vendor!(vendor.id)
    end

    test "delete_vendor/1 deletes the vendor" do
      vendor = vendor_fixture()
      assert {:ok, %Vendor{}} = Vendors.delete_vendor(vendor)
      assert_raise Ecto.NoResultsError, fn -> Vendors.get_vendor!(vendor.id) end
    end

    test "change_vendor/1 returns a vendor changeset" do
      vendor = vendor_fixture()
      assert %Ecto.Changeset{} = Vendors.change_vendor(vendor)
    end
  end
end
