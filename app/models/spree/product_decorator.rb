Spree::Product.class_eval do
  def product_type
    return "" unless Spree::Taxonomy.menu
    taxon = taxons.where(taxonomy_id: Spree::Taxonomy.menu.id).first
    return "" unless taxon
    name = taxon.ancestors.inject("") do |name, ancestor|
      if ancestor == Spree::Taxon.menu
        name
      else
        name += "#{ancestor.name}>" 
      end
    end
    name += taxon.name
  end
end