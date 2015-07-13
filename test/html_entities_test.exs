defmodule HtmlEntitiesTest do
  use ExUnit.Case
  doctest HtmlEntities
  import HtmlEntities

  test "Handles consecutive entities (non-greedy)" do
    assert decode("&aring;&auml;&ouml;") == "åäö"
  end

  test "Ignores unrecognized entities" do
    assert decode("&nosuchentity;") == "&nosuchentity;"
    assert decode("&#nosuchentity;") == "&#nosuchentity;"
    assert decode("&#xxxx;") == "&#xxxx;"
  end
end
