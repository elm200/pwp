class SourceReader
  def initialize(src)
    @lines = src.rstrip.chomp.split(/\r?\n/)
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
