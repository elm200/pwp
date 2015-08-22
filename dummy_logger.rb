class DummyLogger
  def debug(msg)
    $stderr.puts msg
  end
end
