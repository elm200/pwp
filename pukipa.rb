#!/usr/bin/env ruby

require 'logger'
require 'strscan'
require 'uri'

class PukipaParseError < StandardError;end

class Pukipa
  def initialize(plain)
    @plain = plain 
		@log = Logger::new( $deferr )
		@log.level = $DEBUG ?
			Logger::DEBUG :
			($VERBOSE ? Logger::INFO : Logger::WARN)
    @h_start_level = 2
    @pagelist = nil
  end

  # array��pagelist���Ϥ�
  # pagelist��wiki�ڡ������� 
  def pagelist(pagelist,base_uri = '/',suffix = '/')
    @base_uri = base_uri
    @pagelist_suffix = suffix
    if pagelist.size > 0
      #��ʸ���ʲ��Ϥ��⤽���оݳ�
      pagelist.reject!{|pn| pn.size <= 3 }
      pagelist.map!{|pn| Regexp.escape(pn)}
      @pagelist = Regexp.new('(?!<a.*?>.*?)((?:' + pagelist.join(')|(?:') + '))(?!.*?</a>)',Regexp::IGNORECASE )
    end
  end

  # html���Ѵ������֤�
  def to_html
    plain = @plain.gsub(/\r?\n/,"\n").chomp + "\n"
    result = []
    block_regex = /^([:\-+> ]).*\n(?:(?:\1.*\n)+)?/
		@scanner = StringScanner.new( plain )
    while !@scanner.eos?
      if @scanner.scan(/^\n/)
        #����
      elsif @scanner.scan(/^----.*?\n/)
        result << '<hr />'
      elsif @scanner.scan(block_regex)
        result << block_parse(@scanner.matched)
      elsif @scanner.scan(/^\*.*?\n/)
        result << h_parse(@scanner.matched)
      elsif @scanner.scan(/^([^*:\-+> \n].+?\n){1,}/)
        result << block_parse(@scanner.matched)
      elsif @scanner.scan(/(.*)/)
        result << block_parse(@scanner.matched)
      else
        #�����ˤϤ��ʤ��Ϥ��ʤΤǡ�����
        raise PukipaParseError.new
      end
    end
    result.join("\n")
  end
  
  protected
  # h(���Ф�) �Υѡ���
  def h_parse(str)
    str.chomp!

    h_regexs = {
      '*'    => 'h' + @h_start_level.to_s,
      '**'   => 'h' + (@h_start_level + 1).to_s,
      '***'  => 'h' + (@h_start_level + 2).to_s,
      '****' => 'h' + (@h_start_level + 3).to_s,
    }
    h_regexs.each do |tmp_regex,prefix|
      regex = Regexp.new('^' + Regexp.escape(tmp_regex) + '([^*])')
      if str =~ regex 
        str.gsub!(regex,"\\1").gsub!(/^\s+/,'')
        str = "<%s>%s</%s>" % [prefix,str_parse(str),prefix]
        break
      end
    end
    @log.debug "inline:\n%s" % str
    str
  end
  
  #block�ʤ�ΤΥѡ���
  def block_parse(str)
    str.chomp!

    if str =~ /^ /
      str = str.map{|s| s.gsub(/^ /,'')}.join
      # pre�λ���str_parse���ʤ�
      str = ['<pre><code>' + escapeHTML(str),'</code></pre>'].join "\n"
    elsif str =~ /^>/
      str = str.map{|s| s.gsub(/^>/,'')}.join
      str = ['<blockquote><p>',str_parse(str),'</p></blockquote>'].join "\n"
    elsif str =~ /^-/
      str = list_parse(str,'ul')
    elsif str =~ /^\+/
      str = list_parse(str,'ol')
    elsif str =~ /^:/
      str = dl_parse(str)
    else
      str = ['<p>',str_parse(str),'</p>'].join "\n"
    end
    @log.debug "block:\n%s" % str
    str
  end

  # li�Υѡ���
  def list_parse(str,list)
    if list == 'ul'
      regex = /^-/
    else
      regex = /^\+/
    end
    str = str.map{|s| s.gsub(regex,'')}.join
    result = []
    result << "<#{list}>"
    tmp = []
    str.each_line do |s|
      s.chomp!
      if s =~ regex
        tmp << s.gsub(regex,'')
      else
        if tmp.size > 0
          result.pop
          result << list_parse(tmp.join("\n"),list)
          result << "</li>"
          tmp.clear
        end
        result << "<li>#{str_parse(s)}"
        result << "</li>"
      end
    end
    if tmp.size > 0
      result.pop
      result << list_parse(tmp.join("\n"),list)
      result << "</li>"
      tmp.clear
    end
    result << "</#{list}>"
    result.join "\n"
  end

  # dl�Υѡ���
  def dl_parse(str)
    regex = /^:/
    regex2 = /(.*?)\|(.*)/
    str = str.map{|s| s.gsub(regex,'')}.join
    result = []
    result << "<dl>"
    tmp = []
    str.each_line do |s|
      s.chomp!
      m = regex2.match(s)
      if m
        result << "<dt>" + str_parse(m[1]) + "</dt>"
        result << "<dd>" + str_parse(m[2]) + "</dd>"
      else
        result << "<dt>" + str_parse(s) + "</dt>"
      end
    end
    result << "</dl>"
    result.join "\n"
  end

  #ʸ����Υѡ���
  def str_parse(str)
    #URI�ؤμ�ư��󥯤ϰ��ֺǽ�ˤ��
    uri_regex = Regexp.new('(?!\[\[.*?)(' + URI.regexp('http').source + ')(?!.*?\]\])',Regexp::EXTENDED)
    str.gsub!(uri_regex) do |match|
      uri = $1.dup
      re = match
      re = '[[%s:%s]]' % [uri,uri] if not uri =~ /\]\]$/
      re 
    end

    str = escapeHTML(str)

    #���
    str.gsub!(/\[\[(.+?):\s*(https?:\/\/.+?)\s*\]\]/) do
      name = $1.dup
      uri = $2.dup
      '<a class="outlink" href="%s">%s</a>' % [uri,name]
    end

    #�ڡ����˥��
    if @pagelist
      str.gsub!(@pagelist) do
        s = $1.dup
        '<a class="pagelink" href="%s%s%s">%s</a>' % [@base_uri,escape(s),@pagelist_suffix,s]
      end
    end

    str
  end
    
  def escapeHTML(string)
    string.gsub(/&/n, '&amp;').gsub(/\"/n, '&quot;').gsub(/>/n, '&gt;').gsub(/</n, '&lt;')
  end

  def escape(string)
    string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
      '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
  end
end

if $0 == __FILE__
  body =<<EOF
*Wikiʸˡ

**���Ф�
 *h2
 **h3
 ***h4
 ****h5
*h2
**h3
***h4
****h5

**�ꥹ��
 -list
 -list2
 --list2-1
 --list2-2
-list
-list2
--list2-1
--list2-2

**�ֹ��դ��ꥹ��
 +olist
 +olist2
 ++olist2-1
 ++olist2-2
+olist
+olist2
++olist2-1
++olist2-2

**����
 >����ʸ
 >example
>����ʸ
>example

**pre
Ƭ�˥��ڡ����������
 def takahashi
   'takahashi'
 end

**�����
 :apple|���
 :orange|�����
:apple|���
:orange|�����

**���
 [[example:http://example.com]]
[[example:http://example.com]]

�ڡ���̾�ˤϼ�ư��󥯤���롣

��:)ʸˡ
EOF
  pu = Pukipa.new(body)
  pu.pagelist(['ʸˡ','��ư���'])
  puts pu.to_html
end