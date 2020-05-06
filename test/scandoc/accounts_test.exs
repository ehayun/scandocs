defmodule Scandoc.AccountsTest do
  use Scandoc.DataCase

  alias Scandoc.Accounts

  import Scandoc.AccountsFixtures
  import ScandocWeb.Gettext
  alias Scandoc.Accounts.{User, UserToken}

  describe "get_user_by_zehut/1" do
    test "does not return the user if the zehut does not exist" do
      refute Accounts.get_user_by_zehut("unknown@example.com")
    end

    test "returns the user if the zehut exists" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user_by_zehut(user.zehut)
    end
  end

  describe "get_user_by_zehut_and_password/1" do
    test "does not return the user if the zehut does not exist" do
      refute Accounts.get_user_by_zehut_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the user if the password is not valid" do
      user = user_fixture()
      refute Accounts.get_user_by_zehut_and_password(user.zehut, "invalid")
    end

    test "returns the user if the zehut and password are valid" do
      %{id: id} = user = user_fixture()

      assert %User{id: ^id} =
               Accounts.get_user_by_zehut_and_password(user.zehut, valid_user_password())
    end
  end

  describe "get_user!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_user!(-1)
      end
    end

    test "returns the user with the given id" do
      %{id: id} = user = user_fixture()
      assert %User{id: ^id} = Accounts.get_user!(user.id)
    end
  end

  describe "register_user/1" do
    test "requires zehut and password to be set" do
      {:error, changeset} = Accounts.register_user(%{})

      assert %{
               password: ["can't be blank"],
               zehut: ["can't be blank"],
               first_name: ["can't be blank"],
               last_name: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates zehut and password when given" do
      {:error, changeset} =
        Accounts.register_user(%{
          zehut: "not valid",
          password: "not",
          first_name: "first",
          last_name: "last"
        })

      eError = gettext("must have the @ sign and no spaces")
      pError = gettext("should be at least 5 character(s)")

      assert %{
               zehut: [eError],
               password: [pError]
             } = errors_on(changeset)
    end

    test "validates maximum values for e-mail and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.register_user(%{zehut: too_long, password: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).zehut
      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "validates e-mail uniqueness" do
      %{zehut: zehut} = user_fixture()
      {:error, changeset} = Accounts.register_user(%{zehut: zehut})
      assert "has already been taken" in errors_on(changeset).zehut

      # Now try with the upper cased e-mail too, to check that zehut case is ignored.
      {:error, changeset} = Accounts.register_user(%{zehut: String.upcase(zehut)})
      assert "has already been taken" in errors_on(changeset).zehut
    end

    test "registers users with a hashed password" do
      zehut = unique_user_zehut()

      {:ok, user} =
        Accounts.register_user(%{
          zehut: zehut,
          password: valid_user_password(),
          first_name: valid_firstname(),
          last_name: valid_lastname()
        })

      assert user.zehut == zehut
      assert is_binary(user.hashed_password)
      assert is_nil(user.confirmed_at)
      assert is_nil(user.password)
    end
  end

  describe "change_user_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_registration(%User{})
      assert changeset.required == [:password, :zehut, :first_name, :last_name]
    end
  end

  describe "change_user_zehut/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_zehut(%User{})
      assert changeset.required == [:zehut]
    end
  end

  describe "apply_user_zehut/3" do
    setup do
      %{user: user_fixture()}
    end

    test "requires zehut to change", %{user: user} do
      {:error, changeset} = Accounts.apply_user_zehut(user, valid_user_password(), %{})
      assert %{zehut: ["did not change"]} = errors_on(changeset)
    end

    test "validates zehut", %{user: user} do
      {:error, changeset} =
        Accounts.apply_user_zehut(user, valid_user_password(), %{zehut: "not valid"})

      # assert %{zehut: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates maximum value for e-mail for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.apply_user_zehut(user, valid_user_password(), %{zehut: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).zehut
    end

    test "validates e-mail uniqueness", %{user: user} do
      %{zehut: zehut} = user_fixture()

      {:error, changeset} =
        Accounts.apply_user_zehut(user, valid_user_password(), %{zehut: zehut})

      assert "has already been taken" in errors_on(changeset).zehut
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Accounts.apply_user_zehut(user, "invalid", %{zehut: unique_user_zehut()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "applies the e-mail without persisting it", %{user: user} do
      zehut = unique_user_zehut()
      {:ok, user} = Accounts.apply_user_zehut(user, valid_user_password(), %{zehut: zehut})
      assert user.zehut == zehut
      assert Accounts.get_user!(user.id).zehut != zehut
    end
  end

  describe "deliver_update_zehut_instructions/3" do
    setup do
      %{user: user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_update_zehut_instructions(user, "current@example.com", url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.zehut
      assert user_token.context == "change:current@example.com"
    end
  end

  describe "update_user_zehut/2" do
    setup do
      user = user_fixture()
      zehut = unique_user_zehut()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_update_zehut_instructions(%{user | zehut: zehut}, user.zehut, url)
        end)

      %{user: user, token: token, zehut: zehut}
    end

    test "updates the e-mail with a valid token", %{user: user, token: token, zehut: zehut} do
      assert Accounts.update_user_zehut(user, token) == :ok
      changed_user = Repo.get!(User, user.id)
      assert changed_user.zehut != user.zehut
      assert changed_user.zehut == zehut
      assert changed_user.confirmed_at
      assert changed_user.confirmed_at != user.confirmed_at
      refute Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not update e-mail with invalid token", %{user: user} do
      assert Accounts.update_user_zehut(user, "oops") == :error
      assert Repo.get!(User, user.id).zehut == user.zehut
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not update e-mail if user e-mail changed", %{user: user, token: token} do
      assert Accounts.update_user_zehut(%{user | zehut: "current@example.com"}, token) == :error
      assert Repo.get!(User, user.id).zehut == user.zehut
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not update e-mail if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Accounts.update_user_zehut(user, token) == :error
      assert Repo.get!(User, user.id).zehut == user.zehut
      assert Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "change_user_password/2" do
    test "returns a user changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_user_password(%User{})
      assert changeset.required == [:password]
    end
  end

  describe "update_user_password/3" do
    setup do
      %{user: user_fixture()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Accounts.update_user_password(user, valid_user_password(), %{
          password: "not",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 5 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{user: user} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.update_user_password(user, valid_user_password(), %{password: too_long})

      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "validates current password", %{user: user} do
      {:error, changeset} =
        Accounts.update_user_password(user, "invalid", %{password: valid_user_password()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "updates the password", %{user: user} do
      {:ok, user} =
        Accounts.update_user_password(user, valid_user_password(), %{
          password: "new valid password"
        })

      assert is_nil(user.password)
      assert Accounts.get_user_by_zehut_and_password(user.zehut, "new valid password")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Accounts.generate_session_token(user)

      {:ok, _} =
        Accounts.update_user_password(user, valid_user_password(), %{
          password: "new valid password"
        })

      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "generate_session_token/1" do
    setup do
      %{user: user_fixture()}
    end

    test "generates a token", %{user: user} do
      token = Accounts.generate_session_token(user)
      assert user_token = Repo.get_by(UserToken, token: token)
      assert user_token.context == "session"

      # Creating the same token for another user should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%UserToken{
          token: user_token.token,
          user_id: user_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_user_by_session_token/1" do
    setup do
      user = user_fixture()
      token = Accounts.generate_session_token(user)
      %{user: user, token: token}
    end

    test "returns user by token", %{user: user, token: token} do
      assert session_user = Accounts.get_user_by_session_token(token)
      assert session_user.id == user.id
    end

    test "does not return user for invalid token" do
      refute Accounts.get_user_by_session_token("oops")
    end

    test "does not return user for expired token", %{token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "delete_session_token/1" do
    test "deletes the token" do
      user = user_fixture()
      token = Accounts.generate_session_token(user)
      assert Accounts.delete_session_token(token) == :ok
      refute Accounts.get_user_by_session_token(token)
    end
  end

  describe "deliver_user_confirmation_instructions/2" do
    setup do
      %{user: user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_confirmation_instructions(user, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.zehut
      assert user_token.context == "confirm"
    end
  end

  describe "confirm_user/2" do
    setup do
      user = user_fixture()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_confirmation_instructions(user, url)
        end)

      %{user: user, token: token}
    end

    test "confirms the e-mail with a valid token", %{user: user, token: token} do
      assert {:ok, confirmed_user} = Accounts.confirm_user(token)
      assert confirmed_user.confirmed_at
      assert confirmed_user.confirmed_at != user.confirmed_at
      assert Repo.get!(User, user.id).confirmed_at
      refute Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not confirm with invalid token", %{user: user} do
      assert Accounts.confirm_user("oops") == :error
      refute Repo.get!(User, user.id).confirmed_at
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not confirm e-mail if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Accounts.confirm_user(token) == :error
      refute Repo.get!(User, user.id).confirmed_at
      assert Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "deliver_user_reset_password_instructions/2" do
    setup do
      %{user: user_fixture()}
    end

    test "sends token through notification", %{user: user} do
      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_reset_password_instructions(user, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert user_token = Repo.get_by(UserToken, token: :crypto.hash(:sha256, token))
      assert user_token.user_id == user.id
      assert user_token.sent_to == user.zehut
      assert user_token.context == "reset_password"
    end
  end

  describe "get_user_by_reset_password_token/2" do
    setup do
      user = user_fixture()

      token =
        extract_user_token(fn url ->
          Accounts.deliver_user_reset_password_instructions(user, url)
        end)

      %{user: user, token: token}
    end

    test "returns the user with valid token", %{user: %{id: id}, token: token} do
      assert %User{id: ^id} = Accounts.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_id: id)
    end

    test "does not return the user with invalid token", %{user: user} do
      refute Accounts.get_user_by_reset_password_token("oops")
      assert Repo.get_by(UserToken, user_id: user.id)
    end

    test "does not return the user if token expired", %{user: user, token: token} do
      {1, nil} = Repo.update_all(UserToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_user_by_reset_password_token(token)
      assert Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "reset_user_password/3" do
    setup do
      %{user: user_fixture()}
    end

    test "validates password", %{user: user} do
      {:error, changeset} =
        Accounts.reset_user_password(user, %{
          password: "not",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 5 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{user: user} do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.reset_user_password(user, %{password: too_long})
      assert "should be at most 80 character(s)" in errors_on(changeset).password
    end

    test "updates the password", %{user: user} do
      {:ok, updated_user} = Accounts.reset_user_password(user, %{password: "new valid password"})
      assert is_nil(updated_user.password)
      assert Accounts.get_user_by_zehut_and_password(user.zehut, "new valid password")
    end

    test "deletes all tokens for the given user", %{user: user} do
      _ = Accounts.generate_session_token(user)
      {:ok, _} = Accounts.reset_user_password(user, %{password: "new valid password"})
      refute Repo.get_by(UserToken, user_id: user.id)
    end
  end

  describe "inspect/2" do
    test "does not include password" do
      refute inspect(%User{password: "53456"}) =~ "password: \"53456\""
    end
  end
end
