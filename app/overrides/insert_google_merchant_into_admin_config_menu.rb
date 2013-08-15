Deface::Override.new(
  :virtual_path => "spree/admin/configurations/index",
  :name => "insert_google_merchant_into_admin_config_menu",
  :insert_after => "tbody[data-hook='admin_configurations_menu']",
  :text => %(<%= configurations_menu_item(t("google_merchant"), admin_google_merchants_path, t("google_merchants_description")) %>)
)

Deface::Override.new(:virtual_path => "spree/admin/shared/_configuration_menu",
                     :name => "insert_google_merchant_into_admin_configuration_sidebar_menu",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu'], #admin_configurations_sidebar_menu[data-hook]",
                     :text => "<%= configurations_sidebar_menu_item t('google_merchant'), admin_google_merchants_path %>",
                     :disabled => false)