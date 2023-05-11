defmodule RequireAssociations.Associations do
  @doc """
  Turns a set of associations (as used by Ecto's [preload](https://hexdocs.pm/ecto/Ecto.Repo.html#c:preload/3))
  into a list of paths to that association.  Examples are most helpful for understanding this.  Imagine we have
  the following schemas:

    defmodule User do
      use Ecto.Schema

      schema "users" do
        belongs_to :region, Region
        has_many :roles, Role
      end
    end

    defmodule Role do
      use Ecto.Schema

      schema "roles" do
        belongs_to :region, Region
      end
    end


    iex> RequireAssociations.Associations.paths(:region)
    [[:region]]

    iex> RequireAssociations.Associations.paths([:region, :roles])
    [[:region], [:roles]]

    iex> RequireAssociations.Associations.paths([:region, roles: :region])
    [[:region], [:roles], [:roles, :region]]
  """

  def paths(definitions), do: do_paths(definitions, [])

  defp do_paths(definition, prefix) when is_atom(definition), do: [prefix ++ [definition]]
  defp do_paths(definition, prefix) when is_binary(definition), do: do_paths(String.to_atom(definition), prefix)

  defp do_paths(definitions, prefix) when is_list(definitions) do
    Enum.flat_map(definitions, fn
      {key, value} ->
        new_prefix = prefix ++ [key]

        [new_prefix] ++ do_paths(value, new_prefix)

      definition ->
        do_paths(definition, prefix)
    end)
  end
end

