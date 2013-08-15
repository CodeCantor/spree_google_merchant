Spree::Product.class_eval do
  attr_accessible :google_product_category

  def product_type
    return "" unless Spree::Taxonomy.exists?(Spree::GoogleMerchant::Config[:category_taxonomy_id])
    categories = Spree::Taxonomy.find(Spree::GoogleMerchant::Config[:category_taxonomy_id])

    taxon = taxons.where(taxonomy_id: categories.id).first
    return "" unless taxon

    name = taxon.ancestors.inject("") do |name, ancestor|
      if ancestor == categories.root
        name
      else
        name += "#{ancestor.name}>" 
      end
    end
    name += taxon.name
  end
end