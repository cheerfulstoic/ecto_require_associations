# EctoRequireAssociations

If you want to write purely functional functions based on Ecto data, you need to separate out your `Repo.preload`s.  This library helps you insert clean exceptions into those functions to make it clear when you have association dependencies.  See [this blog post TODO!!](---) for a more details discussion.

## Usage

A `EctoRequireAssociations.ensure!/2` function is defined which takes an ecto struct record and a specification of associations.  The specification works the same as the [`Ecto.Repo.preload/3`](https://hexdocs.pm/ecto/Ecto.Repo.html#c:preload/3) callback.

```elixir
def self_edited_posts(person) do
  EctoRequireAssociations.ensure!(person, [:settings, authored_posts: :editor])
  
  # Code which uses person.settings, person.authored_posts, and the
  # `editor` association on the authored posts
end
```

If any of the specified associations aren't loaded an `ArgumentError` will be raised
with a message like:

```
Expected association to be set: `authored_posts`
```

or if a nested preload is missing:

```
Expected association to be set: `authored_posts.editor`
```

If two associations are missing preloads:

```
Expected associations to be set: `settings`, `authored_posts.editor`
```

Ecto's `Ecto.assoc_loaded?/1` is used, so `nil` is considered a loaded value.

If an association isn't defined in the schema, a readable exception is produced instead:

```
Association `authored_psts` is not defined for the `MyApp.People.Person` struct
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ecto_require_associations` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_require_associations, "~> 0.1.3"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ecto_require_associations>.

