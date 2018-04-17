#
#   config/routes.rb      - Routing Definitions
#
#     Luis Esteban    16 April 2018
#       created
#

Rails.application.routes.draw do
  
  #root          'application#index', format: 'json'
  resources     :page_views
  
end
