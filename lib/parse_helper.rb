require_relative './html_utils.rb'

class ParseHelper
  include HTMLUtils

  def initialize(options = {})
    @h_start_level = 2

    @page_names = options[:page_names] || []
    @base_uri = options[:base_uri] || '/'
    @pagelist_suffix = options[:pagelist_suffix] || '/'
  end

  def parse_inline(str)
    str.gsub(inline_re) do
      case
      when htmlchar = $1 then escape(htmlchar)
      when bracket  = $2 then a_href($3, bracket, 'outlink')
      when pagename = $4 then a_href(page_uri(pagename), pagename, 'pagelink')
      when uri      = $5 then a_href(uri, uri, 'outlink')
      else
        raise 'must not happen'
      end
    end
  end

  private

  def inline_re
    @inline_re ||= %r{
    ([&<>"])                             # $1: HTML escape characters
    | \[\[(.+?):\s*(https?://\S+)\s*\]\] # $2: label, $3: URI
    | (#{autolink_re})                   # $4: Page name autolink
    | (#{URI.regexp('http')})            # $5...: URI autolink
    }x
  end

  def a_href(uri, label, cssclass)
    %(<a class="#{cssclass}" href="#{escape(uri)}">#{escape(label)}</a>)
  end

  def autolink_re
    Regexp.union(* @page_names.select { |name| name.size > 3 })
  end

  def page_uri(page_name)
    "#{@base_uri}#{urlencode(page_name)}#{@pagelist_suffix}"
  end
end
