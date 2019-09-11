defmodule HtmlEntitiesTest do
  use ExUnit.Case
  doctest HtmlEntities
  import HtmlEntities

  test "Decoding handles consecutive entities (non-greedy)" do
    assert decode("&aring;&auml;&ouml;") == "åäö"
  end

  test "Decoding ignores unrecognized entities" do
    assert decode("&nosuchentity;") == "&nosuchentity;"
    assert decode("&#nosuchentity;") == "&#nosuchentity;"
    assert decode("&#xxxx;") == "&#xxxx;"
  end

  test "Decoding numbers" do
    assert decode("perhaps an &#x26;?") == "perhaps an &?"
    assert decode("perhaps an &#38;?") == "perhaps an &?"
  end

  test "Encoding doesn't replace safe UTF-8 characters" do
    assert encode("AbcÅäö€") == "AbcÅäö€"
  end

  test "Encoding does replace unsafe characters" do
    assert encode("'\"&<>") == "&apos;&quot;&amp;&lt;&gt;"
  end
end
