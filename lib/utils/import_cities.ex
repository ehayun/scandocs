defmodule Scandoc.Util.ImportCities do
  # import Ecto.Query
  alias Scandoc.Repo

  def run() do
    cities = [
      %{id: 1001, code: "1001", title: "זכרון יעקב"},
      %{id: 1002, code: "1002", title: "חדרה"},
      %{id: 1003, code: "1003", title: "חוף הכרמל"},
      %{id: 1004, code: "1004", title: "חיפה"},
      %{id: 1005, code: "1005", title: "חצור הגלילית"},
      %{id: 1006, code: "1006", title: "חריש"},
      %{id: 1007, code: "1007", title: "טבעון"},
      %{id: 1008, code: "1008", title: "טבריה"},
      %{id: 1009, code: "1009", title: "טירת הכרמל"},
      %{id: 1010, code: "1010", title: "יבניאל"},
      %{id: 1011, code: "1011", title: "יוקנעם"},
      %{id: 1012, code: "1012", title: "ירושלים"},
      %{id: 1013, code: "1013", title: "כפר ורדים"},
      %{id: 1014, code: "1014", title: "כרמיאל"},
      %{id: 1015, code: "1015", title: "מ.א. הגליל התחתון"},
      %{id: 1016, code: "1016", title: "מ.א. זבולון"},
      %{id: 1017, code: "1017", title: "מ.א. מטה אשר"},
      %{id: 1018, code: "1018", title: "מ.א. משגב"},
      %{id: 1019, code: "1019", title: "מ.א. עמק המעיינות"},
      %{id: 1020, code: "1020", title: "מ.א. שומרון"},
      %{id: 1021, code: "1021", title: "מגדל העמק"},
      %{id: 1022, code: "1022", title: "מודיעין עילית"},
      %{id: 1023, code: "1023", title: "מעלות תרשיחא"},
      %{id: 1024, code: "1024", title: "מרום הגליל"},
      %{id: 1025, code: "1025", title: "נהריה"},
      %{id: 1026, code: "1026", title: "נצרת עלית"},
      %{id: 1027, code: "1027", title: "עכו"},
      %{id: 1028, code: "1028", title: "עמק יזרעאל"},
      %{id: 1029, code: "1029", title: "עפולה"},
      %{id: 1030, code: "1030", title: "פרדס חנה - כרכור"},
      %{id: 1031, code: "1031", title: "פתח תקוה"},
      %{id: 1032, code: "1032", title: "צפת"},
      %{id: 1033, code: "1033", title: "קרית אתא"},
      %{id: 1034, code: "1034", title: "קרית ביאליק"},
      %{id: 1035, code: "1035", title: "קרית ים"},
      %{id: 1036, code: "1036", title: "קרית מוצקין"},
      %{id: 1037, code: "1037", title: "רכסים"}
    ]

    for c <- cities do
      now = Calendar.DateTime.now!("UTC")

      Ecto.Adapters.SQL.query!(
        Repo,
        "insert into cities(id, code, title, updated_at, inserted_at) values($1, $2, $3, $4, $4)",
        [c.id, c.code, c.title, now]
      )
    end
  end
end
