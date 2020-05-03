import_if_available(Ecto.Query)
import_if_available(Ecto.Changeset)

defmodule AC do
  def update(schema, changes) do
    schema
    |> Ecto.Changeset.change(changes)
    |> Repo.update()
  end

  # IEx.configure colors: [enabled: true]
  # IEx.configure colors: [ eval_result: [ :cyan, :bright ] ]
  # IO.puts(
  #   IO.ANSI.red_background() <>
  #     IO.ANSI.white() <> " ❄❄❄ Good Luck with Elixir ❄❄❄ " <> IO.ANSI.reset()
  # )

  Application.put_env(:elixir, :ansi_enabled, true)

  IEx.configure(
    colors: [
      eval_result: [:green, :bright],
      eval_error: [[:red, :bright]],
      eval_info: [:yellow, :bright]
    ]
  )
end

just_msg = %{
  "message" => %{
    "chat" => %{
      "first_name" => "gigi",
      "id" => 717_577_739,
      "type" => "private",
      "username" => "elihh1"
    },
    "date" => 1_585_715_359,
    "from" => %{
      "first_name" => "gigi",
      "id" => 717_577_739,
      "is_bot" => false,
      "language_code" => "he",
      "username" => "elihh1"
    },
    "message_id" => 175,
    "text" => "just a message"
  },
  "phone_id" => "3",
  "update_id" => 474_903_658
}

no_phone = %{
  "message" => %{
    "chat" => %{
      "first_name" => "gigi",
      "id" => 717_577_739,
      "type" => "private",
      "username" => "elihh1"
    },
    "date" => 1_585_715_359,
    "from" => %{
      "first_name" => "gigi",
      "id" => 717_577_739,
      "is_bot" => false,
      "language_code" => "he",
      "username" => "elihh1"
    },
    "message_id" => 175,
    "text" => "נכון"
  },
  "phone_id" => "3",
  "update_id" => 474_903_658
}

with_phone = %{
  "message" => %{
    "chat" => %{
      "first_name" => "gigi",
      "id" => 717_577_739,
      "type" => "private",
      "username" => "elihh1"
    },
    "date" => 1_585_715_359,
    "from" => %{
      "first_name" => "gigi",
      "id" => 717_577_739,
      "is_bot" => false,
      "language_code" => "he",
      "username" => "elihh1"
    },
    "message_id" => 176,
    "text" => "0509998888"
  },
  "phone_id" => "3",
  "update_id" => 474_903_658
}

with_name = %{
  "message" => %{
    "chat" => %{
      "first_name" => "gigi",
      "id" => 717_577_739,
      "type" => "private",
      "username" => "elihh1"
    },
    "date" => 1_585_715_359,
    "from" => %{
      "first_name" => "gigi",
      "id" => 717_577_739,
      "is_bot" => false,
      "language_code" => "he",
      "username" => "elihh1"
    },
    "message_id" => 176,
    "text" => "אלי"
  },
  "phone_id" => "3",
  "update_id" => 474_903_658
}

with_last = %{
  "message" => %{
    "chat" => %{
      "first_name" => "gigi",
      "id" => 717_577_739,
      "type" => "private",
      "username" => "elihh1"
    },
    "date" => 1_585_715_359,
    "from" => %{
      "first_name" => "gigi",
      "id" => 717_577_739,
      "is_bot" => false,
      "language_code" => "he",
      "username" => "elihh1"
    },
    "message_id" => 176,
    "text" => "חיון"
  },
  "phone_id" => "3",
  "update_id" => 474_903_658
}

alias Scandoc.Campaigns
alias Scandoc.Campaigns.{CmpMessage, CmpBot, Group}
alias Scandoc.Customers
alias Scandoc.Customers.{Chat, Campaign, Contacts, Label, Bot, Botqa}
alias Scandoc.Customers.Contact
alias Scandoc.Contacts
alias Scandoc.Customers.Phone
alias Scandoc.Customers.Customer
alias Scandoc.Contacts.Chat
alias Scandoc.Contact.CntLabel
alias Scandoc.Groups
alias Scandoc.Groups.{GrpContact, GrpLabel}
alias Scandoc.Jobs.Queue
alias Scandoc.Labels
alias Scandoc.Jobs
alias Scandoc.Jobs.{Bots, Util}
alias Scandoc.Repo
alias Scandoc.Users.User
alias Scandoc.Settings
alias Scandoc.Settings.Setting
alias Scandoc.Statistics
alias Scandoc.Statistics.Log
alias Scandoc.Jobs.TestStress
