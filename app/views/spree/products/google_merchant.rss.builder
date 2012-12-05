xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"

xml.rss "version" => "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
  xml.channel do
    xml.title Spree::GoogleMerchant::Config[:google_merchant_title]
    xml.description Spree::GoogleMerchant::Config[:google_merchant_description]
    
    production_domain = Spree::GoogleMerchant::Config[:production_domain]
    xml.link production_domain
    
    @products.each do |product|
      xml.item do
        xml.id product.id.to_s
        xml.title product.name
        if product.description
          xml.description CGI.escapeHTML(product.description.strip_html_tags)
        end
        xml.link production_domain + 'products/' + product.permalink
        xml.tag! "g:mpn", product.sku.to_s
        xml.tag! "g:id", product.id.to_s
        xml.tag! "g:price", product.price
        xml.tag! "g:condition", "new"
        xml.tag! "g:availability", "in stock"
        if product.property('Brand')
          xml.tag! "g:brand", product.property('Brand') 
        end
        if product.property('Google Product Category')
          xml.tag! "g:google_product_category", product.property('Google Product Category')
        elsif !Spree::GoogleMerchant::Config[:default_category].blank?
          xml.tag! "g:google_product_category", Spree::GoogleMerchant::Config[:default_category]
        end
        if Spree::Taxonomy.respond_to?(:menu) && Spree::Taxonomy.menu 
          xml.tag! "g:product_type", product.product_type
        end
        xml.tag! "g:image_link", product.images.first.attachment.url(:product) unless product.images.empty?
      end
    end
  end
end