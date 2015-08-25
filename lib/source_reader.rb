class SourceReader
  def initialize(src)
    if src.is_a?(Array)
      @lines = src
    else
      @lines = src.rstrip.chomp.split(/\r?\n/)
    end
  end

  def eof?
    @lines.empty?
  end

  def first
    @lines.first
  end

  def take
    @lines.shift
  end

  def take_block(marker)
    buf = []
    until eof?
      break unless marker =~ first
      buf.push take.sub(marker, '')
    end
    buf
  end
end
