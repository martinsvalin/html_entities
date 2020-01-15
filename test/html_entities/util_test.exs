defmodule HtmlEntitiesUtilTest do
  use ExUnit.Case
  doctest HtmlEntities.Util
  import HtmlEntities.Util

  test "Comma-separated entity descriptions are converted to tuples" do
    assert convert_line_to_entity("auml,ä,228") == {"auml", "ä", 228}
    assert convert_line_to_entity("aring,å,229") == {"aring", "å", 229}
    assert convert_line_to_entity("ouml,ö,246") == {"ouml", "ö", 246}
  end

  test "Structurally invalid entity descriptions trigger an error" do
    assert_raise MatchError, fn ->
      convert_line_to_entity("auml,ä,228,foo")
    end

    assert_raise MatchError, fn ->
      convert_line_to_entity("auml,ä")
    end

    assert_raise MatchError, fn ->
      convert_line_to_entity("")
    end
  end

  test "Trailing whitespace is removed from entity descriptions" do
    assert convert_line_to_entity("euro,€,8364 \t") == {"euro", "€", 8364}
  end
end
