Spree::Taxon.class_eval do
  def to_google_name
    name = self.ancestors.inject("") do |name, ancestor|
      name += "#{ancestor.name}>"
    end
    name + self.name
  end
end