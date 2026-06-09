# frozen_string_literal: true

module ComfortableMediaSurfer
  module Content
    # Controller mixin that decorates anchor tags in already-rendered (post-ERB)
    # CMS page HTML. Shared by Comfy::Cms::ContentController (direct CMS routes)
    # and RenderMethods (the `render cms_page:` / `render cms_layout:` embedding
    # API used by host apps) so both paths decorate identically.
    module LinkDecoration
    private

      def decorate_cms_links(html)
        LinkDecorator.new(
          html,
          site_host: @cms_site&.hostname,
          current_path: @cms_page&.full_path,
          cta_class: ComfortableMediaSurfer.config.cta_link_class
        ).call
      end
    end
  end
end
