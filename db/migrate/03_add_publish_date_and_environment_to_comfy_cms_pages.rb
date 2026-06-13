class AddPublishDateAndEnvironmentToComfyCmsPages < ActiveRecord::Migration[7.1]
  def up
    add_column :comfy_cms_pages, :publish_date, :date
    add_column :comfy_cms_pages, :is_published_on_production, :boolean, default: false, null: false
    add_column :comfy_cms_pages, :is_published_on_staging, :boolean, default: true, null: false

    add_index :comfy_cms_pages, :publish_date
    add_index :comfy_cms_pages, :is_published_on_production
    add_index :comfy_cms_pages, :is_published_on_staging

    # Pre-existing pages are live content unless they're new CMS drafts (slug
    # ending in "-cms"). A NULL slug (the site root) counts as pre-existing.
    execute(<<~SQL.squish)
      UPDATE comfy_cms_pages
      SET is_published_on_production = #{connection.quoted_true}
      WHERE slug IS NULL OR slug NOT LIKE '%-cms'
    SQL
  end

  def down
    remove_column :comfy_cms_pages, :is_published_on_staging
    remove_column :comfy_cms_pages, :is_published_on_production
    remove_column :comfy_cms_pages, :publish_date
  end
end
