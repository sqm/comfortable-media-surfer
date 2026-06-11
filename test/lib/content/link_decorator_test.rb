# frozen_string_literal: true

require_relative '../../test_helper'

class ContentLinkDecoratorTest < ActiveSupport::TestCase
  SITE_HOST = 'www.squaremouth.com'

  def decorate(html, site_host: SITE_HOST)
    ComfortableMediaSurfer::Content::LinkDecorator.new(html, site_host:).call
  end

  def test_decorates_external_links
    result = decorate('<a href="https://www.example.com">External</a>')

    assert_includes result, 'target="_blank"'
    assert_includes result, 'rel="noopener nofollow"'
  end

  def test_leaves_internal_links_untouched
    html = %(<a href="https://#{SITE_HOST}/about">Internal</a>)

    assert_equal html, decorate(html)
  end

  def test_leaves_relative_links_untouched
    html = '<a href="/plans">Relative</a>'

    assert_equal html, decorate(html)
  end

  def test_leaves_anchor_and_mailto_links_untouched
    result = decorate('<a href="#x">Jump</a><a href="mailto:a@b.com">Mail</a>')

    refute_includes result, 'target="_blank"'
    refute_includes result, 'rel='
  end

  def test_preserves_full_document_structure
    html = '<!DOCTYPE html><html><head><title>T</title></head>' \
           '<body><a href="https://www.example.com">External</a></body></html>'

    result = decorate(html)

    assert_includes result, '<!DOCTYPE html>'
    assert_includes result, '<head><title>T</title></head>'
    assert_includes result, 'target="_blank"'
  end

  def test_external_decoration_is_idempotent
    once  = decorate('<a href="https://www.example.com">External</a>')
    twice = decorate(once)

    assert_equal once, twice
  end

  def test_does_not_raise_on_anchor_without_href
    assert_nothing_raised { decorate('<a>No href</a>') }
  end
end
