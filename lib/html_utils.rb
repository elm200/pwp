module HTMLUtils
  ESC = {
    '&' => '&amp;',
    '"' => '&quot;',
    '<' => '&lt;',
    '>' => '&gt;'
  }

  def escape(str)
    table = ESC # optimize
    str.gsub(/[&"<>]/) { |s| table[s] }
  end

  def urlencode(str)
    URI.escape(str)
  end
end
