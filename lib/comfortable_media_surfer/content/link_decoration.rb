# frozen_string_literal: true

module ComfortableMediaSurfer
  module Content
    # Controller mixin that decorates anchor tags in rendered CMS page HTML.
    # Decoration runs in an after_action over the full response body — keeping
    # the render a single pass so content_for captures from CMS partials still
    # reach the layout. The CMS render paths queue it explicitly; non-HTML
    # responses (rss, xml, etc.) are skipped since HTML parsing would corrupt
    # them.
    module LinkDecoration
    private

      def queue_cms_link_decoration
        @cms_link_decoration_queued = true
      end

      def decorate_cms_response_links
        return unless @cms_link_decoration_queued && response.media_type == 'text/html'

        @cms_link_decoration_queued = false
        response.body = decorate_cms_links(response.body)
      end

      def decorate_cms_links(html)
        LinkDecorator.new(html, site_host: @cms_site&.hostname).call
      end
    end
  end
end
