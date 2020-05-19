defmodule Scandoc.EmployeesTest do
  use Scandoc.DataCase

  alias Scandoc.Employees

  describe "employees" do
    alias Scandoc.Employees.Employee

    @valid_attrs %{
      date_of_birth: ~D[2010-04-17],
      full_name: "some full_name",
      hashed_password: "some hashed_password",
      is_admin: true,
      is_freezed: true,
      role: "some role",
      zehut: "some zehut"
    }
    @update_attrs %{
      date_of_birth: ~D[2011-05-18],
      full_name: "some updated full_name",
      hashed_password: "some updated hashed_password",
      is_admin: false,
      is_freezed: false,
      role: "some updated role",
      zehut: "some updated zehut"
    }
    @invalid_attrs %{
      date_of_birth: nil,
      full_name: nil,
      hashed_password: nil,
      is_admin: nil,
      is_freezed: nil,
      role: nil,
      zehut: nil
    }

    def employee_fixture(attrs \\ %{}) do
      {:ok, employee} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Employees.create_employee()

      employee
    end

    test "list_employees/0 returns all employees" do
      employee = employee_fixture()
      assert Employees.list_employees() == [employee]
    end

    test "get_employee!/1 returns the employee with given id" do
      employee = employee_fixture()
      assert Employees.get_employee!(employee.id) == employee
    end

    test "create_employee/1 with valid data creates a employee" do
      assert {:ok, %Employee{} = employee} = Employees.create_employee(@valid_attrs)
      assert employee.date_of_birth == ~D[2010-04-17]
      assert employee.full_name == "some full_name"
      assert employee.hashed_password == "some hashed_password"
      assert employee.is_admin == true
      assert employee.is_freezed == true
      assert employee.role == "some role"
      assert employee.zehut == "some zehut"
    end

    test "create_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Employees.create_employee(@invalid_attrs)
    end

    test "update_employee/2 with valid data updates the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{} = employee} = Employees.update_employee(employee, @update_attrs)
      assert employee.date_of_birth == ~D[2011-05-18]
      assert employee.full_name == "some updated full_name"
      assert employee.hashed_password == "some updated hashed_password"
      assert employee.is_admin == false
      assert employee.is_freezed == false
      assert employee.role == "some updated role"
      assert employee.zehut == "some updated zehut"
    end

    test "update_employee/2 with invalid data returns error changeset" do
      employee = employee_fixture()
      assert {:error, %Ecto.Changeset{}} = Employees.update_employee(employee, @invalid_attrs)
      assert employee == Employees.get_employee!(employee.id)
    end

    test "delete_employee/1 deletes the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{}} = Employees.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> Employees.get_employee!(employee.id) end
    end

    test "change_employee/1 returns a employee changeset" do
      employee = employee_fixture()
      assert %Ecto.Changeset{} = Employees.change_employee(employee)
    end
  end

  describe "roles" do
    alias Scandoc.Employees.Role

    @valid_attrs %{code: "some code", title: "some title"}
    @update_attrs %{code: "some updated code", title: "some updated title"}
    @invalid_attrs %{code: nil, title: nil}

    def role_fixture(attrs \\ %{}) do
      {:ok, role} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Employees.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Employees.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Employees.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      assert {:ok, %Role{} = role} = Employees.create_role(@valid_attrs)
      assert role.code == "some code"
      assert role.title == "some title"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Employees.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, %Role{} = role} = Employees.update_role(role, @update_attrs)
      assert role.code == "some updated code"
      assert role.title == "some updated title"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Employees.update_role(role, @invalid_attrs)
      assert role == Employees.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Employees.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Employees.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Employees.change_role(role)
    end
  end
end
