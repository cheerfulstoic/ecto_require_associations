defmodule EctoRequireAssociationsAshTest do
  use ExUnit.Case

  defmodule Person do
    defstruct [
      :id,
      :name,
      best_friend: %Ash.NotLoaded{field: :best_friend, type: :relationship},
      siblings: %Ash.NotLoaded{field: :siblings, type: :relationship}
    ]
  end

  test "association does not exist" do
    assert_raise ArgumentError, ~r/Association `does_not_exist` is not defined/, fn ->
      EctoRequireAssociations.ensure!(%Person{}, :does_not_exist)
    end
  end

  test "association not loaded" do
    assert_raise ArgumentError, "Expected association to be set: `best_friend`", fn ->
      EctoRequireAssociations.ensure!(%Person{}, :best_friend)
    end

    assert_raise ArgumentError, "Expected association to be set: `siblings`", fn ->
      EctoRequireAssociations.ensure!(%Person{}, :siblings)
    end

    assert_raise ArgumentError, "Expected associations to be set: `best_friend`, `siblings`", fn ->
      EctoRequireAssociations.ensure!(%Person{}, [:best_friend, :siblings])
    end

    # Nested: parent loaded, child not
    person = %Person{best_friend: %Person{}}

    assert_raise ArgumentError, "Expected association to be set: `best_friend.best_friend`", fn ->
      EctoRequireAssociations.ensure!(person, best_friend: :best_friend)
    end

    person = %Person{siblings: [%Person{}]}

    assert_raise ArgumentError, "Expected association to be set: `siblings.best_friend`", fn ->
      EctoRequireAssociations.ensure!(person, siblings: :best_friend)
    end
  end

  test "association loaded" do
    person = %Person{best_friend: %Person{best_friend: nil, siblings: []}}
    assert EctoRequireAssociations.ensure!(person, :best_friend) == :ok

    person = %Person{best_friend: nil}
    assert EctoRequireAssociations.ensure!(person, :best_friend) == :ok

    person = %Person{siblings: [%Person{best_friend: nil, siblings: []}]}
    assert EctoRequireAssociations.ensure!(person, :siblings) == :ok

    person = %Person{siblings: []}
    assert EctoRequireAssociations.ensure!(person, :siblings) == :ok

    # Nested loaded
    person = %Person{
      best_friend: %Person{best_friend: %Person{best_friend: nil, siblings: []}, siblings: []}
    }
    assert EctoRequireAssociations.ensure!(person, best_friend: :best_friend) == :ok

    person = %Person{
      siblings: [%Person{best_friend: %Person{best_friend: nil, siblings: []}, siblings: []}]
    }
    assert EctoRequireAssociations.ensure!(person, siblings: :best_friend) == :ok
  end
end
