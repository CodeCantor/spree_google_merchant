class AddGoogleProductCategoryToProducts < ActiveRecord::Migration
  def change
    add_column :spree_products, :google_product_category, :string
  end
end
