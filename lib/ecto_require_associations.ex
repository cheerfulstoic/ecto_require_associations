defmodule EctoRequireAssociations do
  @moduledoc """
  Documentation for `RequireAssociations`.
  """

  alias RequireAssociations.Associations

  def ensure!(records, association_names) when is_list(records) do
    Associations.paths(association_names)
    |> Enum.filter(fn association_name_path ->
      association_names_not_loaded?(records, association_name_path)
    end)
    |> case do
      [] ->
        :ok

      [path] ->
        raise ArgumentError, "Expected association to be set: #{path_to_string(path)}"

      paths ->
        paths_string =
          paths
          |> Enum.map(&path_to_string/1)
          |> Enum.join(", ")

        raise ArgumentError, "Expected associations to be set: #{paths_string}"
    end
  end

  def ensure!(record, association_names), do: ensure!([record], association_names)

  defp path_to_string(path) do
    "`#{Enum.join(path, ".")}`"
  end

  defp association_names_not_loaded?(records, [association_name]) do
    !Enum.all?(records, & assoc_loaded?(&1, association_name))
  end

  defp association_names_not_loaded?(records, [association_name | rest]) do
    records
    |> Enum.map(& Map.get(&1, association_name))
    |> List.flatten()
    |> association_names_not_loaded?(rest)
  end

  defp assoc_loaded?(%Ecto.Association.NotLoaded{}, _), do: true

  defp assoc_loaded?(%struct_mod{} = record, association_name) do
    if Map.has_key?(struct(struct_mod), association_name) do
      record
      |> Map.get(association_name)
      |> Ecto.assoc_loaded?()
    else
      raise ArgumentError, "Association `#{association_name}` is not defined for the `#{Macro.to_string(struct_mod)}` struct"
    end
  end
end
