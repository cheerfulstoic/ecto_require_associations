defmodule RequireAssociations.AssociationsTest do
  use ExUnit.Case

  doctest RequireAssociations.Associations

  alias RequireAssociations.Associations

  describe ".paths" do
    test "empty list" do
      assert Associations.paths([]) == []
    end

    test "single association" do
      assert Associations.paths(:foo) == [[:foo]]
      assert Associations.paths("foo") == [[:foo]]

      assert Associations.paths(:bar) == [[:bar]]
      assert Associations.paths("bar") == [[:bar]]
    end

    test "simple lists" do
      assert Associations.paths([:foo]) == [[:foo]]
      assert Associations.paths(["foo"]) == [[:foo]]

      assert Associations.paths([:foo, :bar]) == [[:foo], [:bar]]
      assert Associations.paths([:foo, "bar"]) == [[:foo], [:bar]]
    end

    test "nested list" do
      assert Associations.paths(foo: :bar) == [
        [:foo],
        [:foo, :bar]
      ]

      assert Associations.paths(foo: "bar") == [
        [:foo],
        [:foo, :bar]
      ]


      assert Associations.paths(foo: [:bar, :baz, biz: :buzz]) == [
        [:foo],
        [:foo, :bar],
        [:foo, :baz],
        [:foo, :biz],
        [:foo, :biz, :buzz]
      ]

      assert Associations.paths(foo: [:bar, "baz", biz: "buzz"]) == [
        [:foo],
        [:foo, :bar],
        [:foo, :baz],
        [:foo, :biz],
        [:foo, :biz, :buzz]
      ]
    end
  end
end

