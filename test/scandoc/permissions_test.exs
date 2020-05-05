defmodule Scandoc.PermissionsTest do
  use Scandoc.DataCase

  alias Scandoc.Permissions

  describe "permissions" do
    alias Scandoc.Permissions.Permission

    @valid_attrs %{permission_type: 42, ref_id: 42, user_id: 42}
    @update_attrs %{permission_type: 43, ref_id: 43, user_id: 43}
    @invalid_attrs %{permission_type: nil, ref_id: nil, user_id: nil}

    def permission_fixture(attrs \\ %{}) do
      {:ok, permission} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Permissions.create_permission()

      permission
    end

    test "list_permissions/0 returns all permissions" do
      permission = permission_fixture()
      assert Permissions.list_permissions() == [permission]
    end

    test "get_permission!/1 returns the permission with given id" do
      permission = permission_fixture()
      assert Permissions.get_permission!(permission.id) == permission
    end

    test "create_permission/1 with valid data creates a permission" do
      assert {:ok, %Permission{} = permission} = Permissions.create_permission(@valid_attrs)
      assert permission.permission_type == 42
      assert permission.ref_id == 42
      assert permission.user_id == 42
    end

    test "create_permission/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Permissions.create_permission(@invalid_attrs)
    end

    test "update_permission/2 with valid data updates the permission" do
      permission = permission_fixture()

      assert {:ok, %Permission{} = permission} =
               Permissions.update_permission(permission, @update_attrs)

      assert permission.permission_type == 43
      assert permission.ref_id == 43
      assert permission.user_id == 43
    end

    test "update_permission/2 with invalid data returns error changeset" do
      permission = permission_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Permissions.update_permission(permission, @invalid_attrs)

      assert permission == Permissions.get_permission!(permission.id)
    end

    test "delete_permission/1 deletes the permission" do
      permission = permission_fixture()
      assert {:ok, %Permission{}} = Permissions.delete_permission(permission)
      assert_raise Ecto.NoResultsError, fn -> Permissions.get_permission!(permission.id) end
    end

    test "change_permission/1 returns a permission changeset" do
      permission = permission_fixture()
      assert %Ecto.Changeset{} = Permissions.change_permission(permission)
    end
  end
end
