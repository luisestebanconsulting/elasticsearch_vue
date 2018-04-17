#
#   test/controllers/page_views_controller_test.rb    - Test PageViewsController
#
#     Luis Esteban    16 April 2018
#       created
#

require 'test_helper'

class PageViewsControllerTest < ActionDispatch::IntegrationTest
  
  test 'create with no parameters' do
    Timecop.freeze do
      post '/page_views',
        headers:  {
          content_type:   'application/json',
          accept:         'application/json',
          cache_control:  'no-cache',
        }
      assert_response :created
      
      assert_assigns :urls,      []
      assert_assigns :after,     1496239200000
      assert_assigns :before,    (Time.now.to_f * 1000).round(0)
      assert_assigns :interval,  1000 * 60 * 60 * 24 * 30 * 6
      assert_assigns :intervals, [1496239200000, 1511791200000]
    end
  end
  
  test 'create with all parameters' do
    body = {
      urls: [
        'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615',
        'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html',
        'http://www.smh.com.au/nsw/premier-gladys-berejiklian-announces-housing-affordability-reforms-20170601-gwi0jn.html',
        'http://www.news.com.au/technology/environment/trump-pulls-us-out-of-paris-climate-agreement/news-story/f5c30a07c595a10a81d67611d0515a0a'
      ],
      after:      '2017 June 1',
      before:     '2017 June 4',
      interval:   '2h'
    }
    
    post '/page_views',
      params:   body,
      headers:  {
        content_type:   'application/json',
        accept:         'application/json',
        cache_control:  'no-cache',
      }
    assert_response :created
    
    assert_assigns :urls,      body[:urls]
    assert_assigns :after,     1496239200000
    assert_assigns :before,    1496498400000
    assert_assigns :interval,  1000 * 60 * 60 * 2
    assert_assigns :intervals, [
      1496239200000, 1496246400000, 1496253600000, 1496260800000, 1496268000000, 1496275200000, 1496282400000, 1496289600000, 1496296800000,
      1496304000000, 1496311200000, 1496318400000, 1496325600000, 1496332800000, 1496340000000, 1496347200000, 1496354400000, 1496361600000,
      1496368800000, 1496376000000, 1496383200000, 1496390400000, 1496397600000, 1496404800000, 1496412000000, 1496419200000, 1496426400000,
      1496433600000, 1496440800000, 1496448000000, 1496455200000, 1496462400000, 1496469600000, 1496476800000, 1496484000000, 1496491200000,
      1496498400000
    ]
  end
  
end
