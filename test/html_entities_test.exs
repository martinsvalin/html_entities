defmodule HtmlEntitiesTest do
  use ExUnit.Case
  doctest HtmlEntities
  import HtmlEntities

  describe "decode/1" do
    test "named" do
      assert decode("&amp;&nbsp;&reg;") == "& ®"
    end

    test "numbers" do
      assert decode("perhaps an &#x26;?") == "perhaps an &?"
      assert decode("perhaps an &#38;?") == "perhaps an &?"
      assert decode("non-breaking&#xa0;space") == "non-breaking space"
    end

    test "handle consecutive entities (non-greedy)" do
      assert decode("&aring;&auml;&ouml;") == "åäö"
    end

    test "ignore unrecognized entities" do
      assert decode("&nosuchentity;") == "&nosuchentity;"
      assert decode("&#nosuchentity;") == "&#nosuchentity;"
      assert decode("&#xxxx;") == "&#xxxx;"
    end
  end

  describe "encode/1" do
    test "don't replace safe UTF-8 characters" do
      assert encode("AbcÅäö€") == "AbcÅäö€"
    end

    test "replace unsafe characters" do
      assert encode("'\"&<>") == "&apos;&quot;&amp;&lt;&gt;"
    end
  end
end
