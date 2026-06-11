class AddPublishDateAndEnvironmentToComfyCmsPages < ActiveRecord::Migration[7.1]
  def change
    add_column :comfy_cms_pages, :publish_date, :date
    add_column :comfy_cms_pages, :is_published_on_production, :boolean, default: true, null: false
    add_column :comfy_cms_pages, :is_published_on_staging, :boolean, default: true, null: false

    add_index :comfy_cms_pages, :publish_date
    add_index :comfy_cms_pages, :is_published_on_production
    add_index :comfy_cms_pages, :is_published_on_staging
  end
end
