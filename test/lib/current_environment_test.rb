# frozen_string_literal: true

require_relative '../test_helper'

class CurrentEnvironmentTest < ActiveSupport::TestCase
  Subject = ComfortableMediaSurfer::Cms::CurrentEnvironment

  def test_published_column_is_production_in_production
    Rails.env.stubs(:production?).returns(true)
    assert_equal :is_published_on_production, Subject.published_column
  end

  def test_published_column_is_staging_outside_production
    Rails.env.stubs(:production?).returns(false)
    assert_equal :is_published_on_staging, Subject.published_column
  end

  def test_label_is_production_in_production
    Rails.env.stubs(:production?).returns(true)
    assert_equal 'production', Subject.label
  end

  def test_label_is_staging_outside_production
    Rails.env.stubs(:production?).returns(false)
    assert_equal 'staging', Subject.label
  end

  def test_published_columns_maps_each_bucket_to_its_column
    assert_equal(
      { production: :is_published_on_production, staging: :is_published_on_staging },
      Subject::PUBLISHED_COLUMNS
    )
  end
end
