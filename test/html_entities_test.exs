defmodule HtmlEntitiesTest do
  use ExUnit.Case
  import HtmlEntities

  test "decode &amp;" do
    assert decode("This &amp; that") == "This & that"
  end

  test "decode &#34;" do
    assert decode("This &#38; that") == "This & that"
  end
end
