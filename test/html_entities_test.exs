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

    test "ignore invalid unicode codepoints" do
      assert decode("&#55555;") == "&#55555;"
      assert decode("&#xD903;") == "&#xD903;"
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

  test "Encoding when existing escaped characters exist" do
    assert encode("this has both unsafe characters &<> and an existing &amp; entity") ==
             "this has both unsafe characters &amp;&lt;&gt; and an existing &amp; entity"
  end

  test "Multiple Encodings of the same string will consistent with one single encoding pass" do
    original_string = "this has both unsafe characters &<> and an existing &amp; entity"

    first_pass = encode(original_string)
    second_pass = encode(first_pass)
    third_pass = encode(second_pass)

    assert first_pass == second_pass
    assert third_pass == second_pass
  end
end
