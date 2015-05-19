require 'redcloth'
module RedCloth
  class TextileDoc < String
    def to_plain
      html = to(RedCloth::Formatters::HTML)
      return strip_redcloth_html(html).gsub('&#8216;', "'").gsub('&#8217;', "'").gsub('&#8220;', '"').gsub('&#8221;', '"')
    end

    private

      def strip_redcloth_html(html)
        return html.dup.gsub(html_regexp, '') do |h|
          redcloth_glyphs.each do |(entity, char)|
            sub = [ :gsub!, entity, char ]
            @textiled_unicode ? h.chars.send(*sub) : h.send(*sub)
          end
        end
      end

      def redcloth_glyphs
        [
          [ '&#8217;', "'" ], 
          [ '&#8216;', "'" ],
          [ '&lt;', '<' ], 
          [ '&gt;', '>' ], 
          [ '&#8221;', '"' ],
          [ '&#8220;', '"' ],            
          [ '&#8230;', '...' ],
          [ '\1&#8212;', '--' ], 
          [ ' &rarr; ', '->' ], 
          [ ' &#8211; ', '-' ], 
          [ '&#215;', 'x' ], 
          [ '&#8482;', '(TM)' ], 
          [ '&#174;', '(R)' ],
          [ '&#169;', '(C)' ]
        ]
      end

      def html_regexp
        %r{<(?:[^>"']+|"(?:\\.|[^\\"]+)*"|'(?:\\.|[^\\']+)*')*>}xm
      end

  end
end
