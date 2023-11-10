ExUnit.start()
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(Kolektanto.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:ex_machina)

Hammox.defmock(TagsMock, for: Kolektanto.Tags.Behaviour)
Hammox.defmock(ItemsMock, for: Kolektanto.Items.Behaviour)
