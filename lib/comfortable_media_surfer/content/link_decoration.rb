# frozen_string_literal: true

module ComfortableMediaSurfer
  module Content
    # Controller mixin that decorates anchor tags in rendered CMS page HTML.
    # Every CMS render path funnels through the RenderMethods#render override,
    # which calls decorate_cms_response_links right after Rails' render writes
    # the response body — a single render pass, so content_for captures from
    # CMS partials still reach the layout. A callback would not work here:
    # host apps commonly render CMS pages from their own rescue_from handlers,
    # where after_action callbacks are skipped. Non-HTML responses (rss, xml,
    # etc.) are skipped since HTML parsing would corrupt them.
    module LinkDecoration
    private

      def decorate_cms_response_links
        return unless response.media_type == 'text/html'

        response.body = decorate_cms_links(response.body)
      end

      def decorate_cms_links(html)
        LinkDecorator.new(html, site_host: @cms_site&.hostname).call
      end
    end
  end
end
