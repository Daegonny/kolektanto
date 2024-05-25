# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kolektanto.Repo.insert!(%Kolektanto.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Kolektanto.Items.Item
alias Kolektanto.Tags.Tag
alias Kolektanto.Repo
alias Faker

tag_names = ~w(summer winter autumn spring red green blue yellow day night)

tags =
  Enum.map(tag_names, fn tag_name ->
    Repo.insert!(%Tag{name: tag_name})
  end)

for _ <- 1..20 do
  random_quantity = Faker.random_between(0, 4)
  tags = Enum.take_random(tags, random_quantity)

  Repo.insert!(%Item{
    name: Faker.Pokemon.En.name(),
    tags: tags
  })
end
