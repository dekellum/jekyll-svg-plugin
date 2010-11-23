#--
# Copyright (c) 2010 David Kellum
# All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

require 'jekyll-svg-plugin/base'

# FIXME: Should create a bug to get this added to jekyll
require 'webrick'
mime_types = WEBrick::HTTPUtils::DefaultMimeTypes
mime_types.store 'svg', 'image/svg+xml'

require 'image_size'

module Jekyll

  class SvgTag < Liquid::Tag
    def initialize( tag_name, svg, tokens )
      super
      @svg = svg.strip
    end

    def render(context)
      png = @svg.sub( /(\.svg)$/, '.png' )
      png_file = png

      # png file is relative to this page, if relative
      unless png_file =~ %r{^/}
        png_file = File.join( File.dirname( context[ 'page' ][ 'url' ] ), png )
      end

      # And found in the site source
      png_file = File.join( context.registers[ :site ].source, png_file )

      w,h = open( png_file, 'rb' ) do |fpng|
        ImageSize.new( fpng.read ).get_size
      end
      <<END
<div class="svg-object">
  <object data="#{@svg}" type="image/svg+xml" width="#{w}" height="#{h}">
    <img src="#{png}" width="#{w}" height="#{h}" />
  </object>
</div>
END
    end
  end
end

Liquid::Template.register_tag('svg', Jekyll::SvgTag)
