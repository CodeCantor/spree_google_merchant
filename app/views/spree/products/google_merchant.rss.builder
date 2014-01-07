xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"

xml.rss "version" => "2.0", "xmlns:g" => "http://base.google.com/ns/1.0" do
  xml.channel do
    xml.title "Nigra Mercato"
    xml.description "Nigra Mercato es una tienda de Sneakers & Streetwear ubicada en el centro de Madrid, en el histórico Barrio de Las Letras. Tenemos las mejores marcas de ropa y zapatillas como Nike, New Balance, Vans, Obey, Diamond Supply, Huf, The Quiet Life, Supra, Rockwell by Parra o DPBS."
    
    production_domain = "http://nigramercato.com"
    xml.link production_domain

    brands_ids = Spree::Taxonomy.find_by(name: 'Brands').taxons.map(&:id)
    @products.each do |product|
    #product = @products.first
      product.variants.each do |variant|
        xml.item do
          xml.id variant.id.to_s
          if product.description
            xml.description CGI.escapeHTML(product.meta_description.split.map(&:capitalize).join(' ') + '. ' + product.description.strip_html_tags)
          end
          xml.link production_domain + '/products/' + product.permalink
          xml.tag! "g:id", variant.id.to_s
          xml.tag! "g:price", product.master.default_price.money.to_html({with_currency: true, symbol: false})
          xml.tag! "g:condition", "new"
          xml.tag! "g:image_link", production_domain + product.images.first.attachment.url(:original).split('?').first unless product.images.empty?
          product.images.each_with_index do |image,index|
            next if index == 0
            xml.tag! "g:additional_image_link", production_domain + image.attachment.url(:original).split('?').first
          end

          stock = product.in_stock? ? "in stock" : "out of stock"
          xml.tag! "g:availability", stock
          xml.tag! "g:sale_price", product.sale_price.to_html(with_currency: true, symbol: false) if product.on_sale?


          xml.tag! "g:mpn", variant.sku.to_s

          brand = product.taxons.where(id: brands_ids).first
          if brand
            xml.tag! "g:brand", brand.name
            xml.tag! "g:title", "#{brand.name} #{product.name.split.map(&:capitalize).join(' ')}"
          else
            xml.tag! "g:title", product.name.split.map(&:capitalize).join(' ')
          end

          product.taxons.where.not(id: brands_ids).each do |taxon|
            xml.tag! "g:product_type", taxon.to_google_name
          end

          if product.variants.count > 0
            size = variant.option_values.first.presentation
            xml.tag! "g:size", size
            xml.tag! "g:item_group_id", product.sku.to_s
          else
          end

          # Category used in the Google Merchant - Categoria usada no Google Merchant
          #if !product.google_product_category.blank?
          #  xml.tag! "g:google_product_category", product.google_product_category
          #elsif !Spree::GoogleMerchant::Config[:default_category].blank?
          #  xml.tag! "g:google_product_category", Spree::GoogleMerchant::Config[:default_category]
          #end
          #
          ## Category used in the store - Categoria usada na loja
          #if Spree::GoogleMerchant::Config[:category_taxonomy_id] && Spree::Taxonomy.exists?(Spree::GoogleMerchant::Config[:category_taxonomy_id])
          #  xml.tag! "g:product_type", product.product_type
          #end

        end
      end
    end
  end
end