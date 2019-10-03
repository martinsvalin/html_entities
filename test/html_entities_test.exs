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
