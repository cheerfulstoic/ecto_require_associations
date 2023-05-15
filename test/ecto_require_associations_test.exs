defmodule EctoRequireAssociationsTest do
  use ExUnit.Case

  defmodule Person do
    use Ecto.Schema

    schema "people" do
      field :name, :string

      belongs_to :best_friend, Person

      belongs_to :siblings, Person
    end
  end

  test "association does not exist" do
    assert_raise ArgumentError, "Association `does_not_exist` is not defined for the `EctoRequireAssociationsTest.Person` struct", fn ->
      EctoRequireAssociations.ensure!(%Person{}, :does_not_exist)
    end

    assert_raise ArgumentError, "Association `not_exsiting` is not defined for the `EctoRequireAssociationsTest.Person` struct", fn ->
      person = %Person{
        siblings: [%Person{}]
      }

      EctoRequireAssociations.ensure!(person, siblings: :not_exsiting)
    end

  end

  test "association not loaded" do
    assert_raise ArgumentError, "Expected association to be set: `best_friend`", fn ->
      EctoRequireAssociations.ensure!(%Person{}, :best_friend)
    end

    assert_raise ArgumentError, "Expected association to be set: `best_friend`", fn ->
      EctoRequireAssociations.ensure!([%Person{}], :best_friend)
    end

    assert_raise ArgumentError, "Expected association to be set: `best_friend`", fn ->
      EctoRequireAssociations.ensure!(%Person{}, "best_friend")
    end

    assert_raise ArgumentError, "Expected association to be set: `siblings`", fn ->
      EctoRequireAssociations.ensure!(%Person{}, :siblings)
    end

    assert_raise ArgumentError, "Expected association to be set: `siblings`", fn ->
      EctoRequireAssociations.ensure!(%Person{}, "siblings")
    end

    assert_raise ArgumentError, "Expected associations to be set: `best_friend`, `siblings`", fn ->
      EctoRequireAssociations.ensure!(%Person{}, [:best_friend, :siblings])
    end

    assert_raise ArgumentError, "Expected associations to be set: `best_friend`, `siblings`", fn ->
      EctoRequireAssociations.ensure!([%Person{}], [:best_friend, :siblings])
    end

    assert_raise ArgumentError, "Expected associations to be set: `best_friend`, `siblings`", fn ->
      EctoRequireAssociations.ensure!(%Person{}, ["best_friend", "siblings"])
    end

    # Nested:
    person = %Person{
      best_friend: %Person{}
    }

    assert_raise ArgumentError, "Expected association to be set: `best_friend.best_friend`", fn ->
      assert EctoRequireAssociations.ensure!(person, best_friend: :best_friend)
    end

    assert_raise ArgumentError, "Expected association to be set: `best_friend.best_friend`", fn ->
      assert EctoRequireAssociations.ensure!([person], best_friend: :best_friend)
    end

    person = %Person{
      siblings: [%Person{}]
    }

    assert_raise ArgumentError, "Expected association to be set: `siblings.best_friend`", fn ->
      assert EctoRequireAssociations.ensure!(person, siblings: :best_friend)
    end

    assert_raise ArgumentError, "Expected association to be set: `siblings.best_friend`", fn ->
      assert EctoRequireAssociations.ensure!([person], siblings: :best_friend)
    end

    assert_raise ArgumentError, "Expected association to be set: `siblings.best_friend`", fn ->
      assert EctoRequireAssociations.ensure!(person, siblings: "best_friend")
    end
  end

  test "association loaded" do
    person = %Person{
      best_friend: %Person{}
    }

    assert EctoRequireAssociations.ensure!(person, :best_friend) == :ok
    assert EctoRequireAssociations.ensure!([person], :best_friend) == :ok
    assert EctoRequireAssociations.ensure!(person, "best_friend") == :ok

    person = %Person{
      best_friend: nil
    }

    assert EctoRequireAssociations.ensure!(person, :best_friend) == :ok
    assert EctoRequireAssociations.ensure!([person], :best_friend) == :ok
    assert EctoRequireAssociations.ensure!(person, "best_friend") == :ok

    person = %Person{
      siblings: [%Person{}]
    }

    assert EctoRequireAssociations.ensure!(person, :siblings) == :ok
    assert EctoRequireAssociations.ensure!([person], :siblings) == :ok
    assert EctoRequireAssociations.ensure!(person, "siblings") == :ok

    person = %Person{
      siblings: []
    }

    assert EctoRequireAssociations.ensure!(person, :siblings) == :ok
    assert EctoRequireAssociations.ensure!([person], :siblings) == :ok
    assert EctoRequireAssociations.ensure!(person, "siblings") == :ok

    person = %Person{
      best_friend: %Person{},
      siblings: []
    }

    assert EctoRequireAssociations.ensure!(person, [:best_friend, :siblings]) == :ok
    assert EctoRequireAssociations.ensure!([person], [:best_friend, :siblings]) == :ok

    # Nested:
    person = %Person{
      best_friend: %Person{
        best_friend: %Person{}
      }
    }

    assert EctoRequireAssociations.ensure!(person, best_friend: :best_friend) == :ok
    assert EctoRequireAssociations.ensure!([person], best_friend: :best_friend) == :ok

    person = %Person{
      siblings: [%Person{
        best_friend: %Person{}
      }]
    }

    assert EctoRequireAssociations.ensure!(person, siblings: :best_friend) == :ok
    assert EctoRequireAssociations.ensure!([person], siblings: :best_friend) == :ok
  end
end
