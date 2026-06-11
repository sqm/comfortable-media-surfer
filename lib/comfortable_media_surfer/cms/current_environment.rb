# frozen_string_literal: true

module ComfortableMediaSurfer
  module Cms
    # Single source of truth for the Rails.env => published-column mapping used
    # by Comfy CMS page publishing. Lifts the column names into a constant
    # because the admin page form needs *both* names, not just the current
    # environment's.
    #
    # Every consuming codebase drafts content on staging and promotes it to
    # production, so the production/staging buckets are a shared convention. The
    # only host-specific seam is +current_bucket+ — override it if a codebase
    # ever detects its environment differently.
    module CurrentEnvironment
    module_function

      PUBLISHED_COLUMNS = {
        production: :is_published_on_production,
        staging: :is_published_on_staging
      }.freeze

      def published_column
        PUBLISHED_COLUMNS.fetch(current_bucket)
      end

      def label
        current_bucket.to_s
      end

      def current_bucket
        Rails.env.production? ? :production : :staging
      end
    end
  end
end
