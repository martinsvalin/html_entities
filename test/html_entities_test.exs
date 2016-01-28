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

  test "Encoding doesn't replace safe UTF-8 characters" do
    assert encode("AbcÅäö€") == "AbcÅäö€"
  end

  test "Encoding does replace unsafe characters" do
    assert encode("'\"&<>") == "&apos;&quot;&amp;&lt;&gt;"
  end
end
