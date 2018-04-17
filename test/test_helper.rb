#
#   test/test_helper.rb     - Helper Methods for Testing
#
#     Luis Esteban    17 April 2018
#       created
#

ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  
  fixtures :all

  def assert_assigns(variable, value)
    assert_equal value, assigns(variable)
  end
  
end
