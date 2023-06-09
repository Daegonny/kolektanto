ExUnit.start()
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(Kolektanto.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:ex_machina)

Mox.defmock(TagsMock, for: Kolektanto.Tag.Tags.Behaviour)
Mox.defmock(ItemsMock, for: Kolektanto.Item.Items.Behaviour)
Mox.defmock(ItemContextMock, for: Kolektanto.Item.Context.Behaviour)
