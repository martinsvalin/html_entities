defmodule HtmlEntitiesUtilTest do
  use ExUnit.Case
  doctest HtmlEntities.Util
  import HtmlEntities.Util

  test "Comma-separated entity descriptions are converted to tuples" do
    entity_defs = ["auml,ä,228", "aring,å,229", "ouml,ö,246"]

    assert convert_lines_to_entities(entity_defs) == [
      {"auml", "ä", "228"},
      {"aring", "å", "229"},
      {"ouml", "ö", "246"}
    ]
  end

  test "Structurally invalid entity descriptions trigger an error" do
    assert_raise MatchError, fn ->
      convert_lines_to_entities(["auml,ä,228,foo"])
    end
    assert_raise MatchError, fn ->
      convert_lines_to_entities(["auml,ä"])
    end
    assert_raise MatchError, fn ->
      convert_lines_to_entities([""])
    end
  end

  test "Trailing whitespace is removed from entity descriptions" do
    assert convert_lines_to_entities(["euro,€,8364 \t"]) == [{"euro","€","8364"}]
  end
end
