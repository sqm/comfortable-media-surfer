# frozen_string_literal: true

module ComfortableMediaSurfer
  module Content
    # Decorates anchor tags in a blob of rendered HTML: marks external links
    # nofollow/blank. Request-free so it can run at content-cache generation
    # time. The host is injected by the caller and it's a no-op on content with
    # no matching anchors.
    class LinkDecorator
      def initialize(html, site_host:)
        @html      = html.to_s
        @site_host = site_host.to_s
      end

      def call
        # No anchors → return the original bytes untouched. Parsing + re-serializing
        # would needlessly normalize the HTML (quote style, void tags, whitespace).
        return @html unless @html.match?(%r{<a[\s>]}i)

        fragment = Nokogiri::HTML.fragment(@html)
        fragment.css('a').each { |link| decorate_external(link) }
        fragment.to_html
      end

    private

      def decorate_external(link)
        href = link['href'].to_s
        return unless href.match?(%r{^http.?://}) && href.exclude?(@site_host)

        link['target'] = '_blank'
        link['rel']    = 'noopener nofollow'
      end
    end
  end
end
