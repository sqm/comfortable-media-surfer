# frozen_string_literal: true

module ComfortableMediaSurfer
  module Content
    # Decorates anchor tags in rendered HTML — a fragment or a full document —
    # marking external links nofollow/blank. The host is injected by the caller
    # and it's a no-op on content with no matching anchors.
    class LinkDecorator
      def initialize(html, site_host:)
        @html      = html.to_s
        @site_host = site_host.to_s
      end

      def call
        # No anchors → return the original bytes untouched. Parsing + re-serializing
        # would needlessly normalize the HTML (quote style, void tags, whitespace).
        return @html unless @html.match?(%r{<a[\s>]}i)

        tree = parse
        tree.css('a').each { |link| decorate_external(link) }
        tree.to_html
      end

    private

      # The HTML5 parser is required here: HTML4 fragment parsing strips the
      # doctype and <html>/<head> structure from full documents.
      def parse
        return Nokogiri::HTML5(@html) if full_document?

        Nokogiri::HTML5.fragment(@html)
      end

      def full_document?
        @html.match?(%r{\A\s*(?:<!doctype|<html[\s>])}i)
      end

      def decorate_external(link)
        href = link['href'].to_s
        return unless href.match?(%r{^http.?://}) && href.exclude?(@site_host)

        link['target'] = '_blank'
        link['rel']    = 'noopener nofollow'
      end
    end
  end
end
