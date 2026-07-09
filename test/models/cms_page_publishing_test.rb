# frozen_string_literal: true

require_relative '../test_helper'

# Environment-scoped publishing: the `:published` scope and `#publicly_visible?`
# gate on the current environment's flag and an optional future publish_date,
# on top of the base `is_published` flag.
class CmsPagePublishingTest < ActiveSupport::TestCase
  setup do
    @site   = comfy_cms_sites(:default)
    @layout = comfy_cms_layouts(:default)
    @root   = comfy_cms_pages(:default)
  end

  def create_page(slug:, **attrs)
    @site.pages.create!(
      { label: 'Child', slug: slug, parent: @root, layout: @layout }.merge(attrs)
    )
  end

  def published?(page)
    Comfy::Cms::Page.published.include?(page)
  end

  # -- .published scope, per environment ---------------------------------------

  def assert_environment_scoped(env_column)
    assert published?(create_page(slug: 'a', env_column => true, publish_date: nil)),
           'includes a page flagged for this env with no publish_date'
    refute published?(create_page(slug: 'b', env_column => true, is_published: false)),
           'excludes a page where is_published is false'
    refute published?(create_page(slug: 'c', env_column => false)),
           'excludes a page where the env flag is false'
    refute published?(create_page(slug: 'd', env_column => true, publish_date: Date.current + 1)),
           'excludes a page whose publish_date is in the future'
    assert published?(create_page(slug: 'e', env_column => true, publish_date: Date.current)),
           'includes a page whose publish_date is today'
  end

  def test_published_scope_in_production
    Rails.env.stubs(:production?).returns(true)
    assert_environment_scoped(:is_published_on_production)
  end

  def test_published_scope_in_staging
    Rails.env.stubs(:production?).returns(false)
    assert_environment_scoped(:is_published_on_staging)
  end

  # -- .published environment isolation ----------------------------------------

  def test_published_isolates_environments
    prod_only  = create_page(slug: 'prod-only',  is_published_on_production: true,  is_published_on_staging: false)
    stage_only = create_page(slug: 'stage-only', is_published_on_production: false, is_published_on_staging: true)

    Rails.env.stubs(:production?).returns(true)
    assert published?(prod_only),  'production-only page is visible in production'
    refute published?(stage_only), 'staging-only page is hidden in production'

    Rails.env.stubs(:production?).returns(false)
    assert published?(stage_only), 'staging-only page is visible in staging'
    refute published?(prod_only),  'production-only page is hidden in staging'
  end

  # -- #publicly_visible? ------------------------------------------------------

  def test_publicly_visible_when_every_gate_passes
    Rails.env.stubs(:production?).returns(false)
    page = create_page(slug: 'v', is_published_on_staging: true, publish_date: nil)

    assert page.publicly_visible?
    assert published?(page)
  end

  def test_not_publicly_visible_when_env_flag_off
    Rails.env.stubs(:production?).returns(false)
    page = create_page(slug: 'nv', is_published_on_staging: false)

    refute page.publicly_visible?
    refute published?(page)
  end
end
