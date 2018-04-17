#
#   app/controllers/page_views_controller.rb      - Controller for generating Page Views charts
#
#     Luis Esteban    16 April 2018
#       created
#

require 'time'


##
# The +PageViewsController+ class implements an API interface to an ElasticSearch data source
# and presents the results as a chart using Vue.

class PageViewsController < ApplicationController
  
  ##
  # Defines time units in milliseconds
  TIME_UNITS =  {
    'm'   => 1,
    's'   => 1000,                          # Second
    'min' => 1000 * 60,                     # Minute
    'h'   => 1000 * 60 * 60,                # Hour
    'd'   => 1000 * 60 * 60 * 24,           # Day
    'w'   => 1000 * 60 * 60 * 24 * 7,       # Week
    'mon' => 1000 * 60 * 60 * 24 * 30,      # Month (as 30 days)
    'y'   => 1000 * 60 * 60 * 24 * 365.25,  # Year
  }

  ##
  # Process +JSON+ +POST+ requests.
  # 
  # +params[:urls]+ specifies the URLs to search for page views
  # +params[:after]+ specifies the beginning of the time range to search for page view events, e.g.
  #   { after: 1496239200000 }
  #   { after: '01/06/2017' }
  #   { after: '2017-06-01 00:00:00' }
  #   { after: '2017 June 01 00:00:00' }
  # +params[:before]+ specifies the end of the time range to search for page view events, e.g.
  #   { before: 1496239200000 }
  #   { before: '01/06/2017' }
  #   { before: '2017-06-01 00:00:00' }
  #   { before: '2017 June 01 00:00:00' }
  # +params[:interval]+ specifies the size to divide the time range into when searching for page views, e.g.
  # The following specify intervals of: 12 hours, 1 week, 14 days, and 1 day
  #   { interval: '12h' }
  #   { interval: 'w' }
  #   { interval: '14' }
  #   {  }
  
  def create
    # -- Parameters --
    @urls     = params[:urls    ] || []
    @after    = params[:after   ] || date_to_milliseconds('01/06/2017')
    @before   = params[:before  ] || now_in_milliseconds
    @interval = params[:interval] || '6mon'
    
    
    # -- Set Date Range --
    if @before.is_a?(String)
      @before = date_to_milliseconds(@before)
    end
    
    if @after.is_a?(String)
      @after = date_to_milliseconds(@after)
    end
    
    
    # -- Set Date Interval --
    @interval = expand_interval(@interval)
    

    # -- Generate Query --
    @intervals = []
    (@after..@before).step(@interval) do |interval|
      @intervals << interval
    end

    # -- Render --
    render status: :created,
      json: {
        urls:       @urls,
        before:     @before,
        after:      @after,
        interval:   @interval,
        intervals:  @intervals,
      }
  end
  
  private
  
  ##
  # Expands a human readable interval definition into milliseconds.
  # See the TIME_UNITS constant for the available units.
  def expand_interval(interval = @interval)
    case interval
      when /\A([0-9]+)([a-z]+)\Z/
        value = $1.to_i
        units = TIME_UNITS[$2] || TIME_UNITS['d']
      when /\A([0-9]+)\Z/
        value = $1.to_i
        units =                   TIME_UNITS['d']
      when /\A([a-z]+)\Z/
        value = 1
        units = TIME_UNITS[$1] || TIME_UNITS['d']
      else
        value = 1
        units =                   TIME_UNITS['d']
    end
    
    value * units
  end
  
  ##
  # Converts a String date to milliseconds
  def date_to_milliseconds(date)
    (Time.parse(date).to_f * 1000).round(0)
  end
  
  ##
  # Converts milliseconds to a Time object
  def milliseconds_to_date(milliseconds)
    seconds      = milliseconds / 1000
    microseconds = milliseconds % 1000 * 1000
    
    Time.at(seconds, microseconds)
  end
  
  ##
  # Returns the time now as milliseconds
  def now_in_milliseconds
    (Time.now.to_f * 1000).round(0)
  end
  
end
