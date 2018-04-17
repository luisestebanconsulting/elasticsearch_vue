#
#   app/controllers/page_views_controller.rb      - Controller for generating Page Views charts
#
#     Luis Esteban    16 April 2018
#       created
#

require 'time'
require 'elasticsearch'
require 'dotenv/load'


##
# The +PageViewsController+ class implements an API interface to an ElasticSearch data source
# and presents the results as a chart using Vue.

class PageViewsController < ApplicationController
  
  DATA_HOST     = ENV['DATA_HOST']
  DATA_USER     = ENV['DATA_USER']
  DATA_PASSWORD = ENV['DATA_PASSWORD']
  
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
    @query = generate_page_views_query
    
    
    # -- Create Client --
    @client = Elasticsearch::Client.new(
      #trace:      true,
      #log:        true,
      host:       DATA_HOST,
      user:       DATA_USER,
      password:   DATA_PASSWORD,
    )
    
    
    # -- Get Data --
    @data = @client.search(
      index:  'events',
      body:   @query
    )
    
    
    # -- Extract Results --
    @results = extract_page_views_results
    
    
    # -- Render --
    render status: :created,
      json: {
        urls:       @urls,
        before:     @before,
        after:      @after,
        interval:   @interval,
        intervals:  @intervals,
        results:    @results,
      }
  end
  
  private
  
  def generate_page_views_query
    @intervals = []
    (@after..@before).step(@interval) do |interval|
      @intervals << interval
    end
    
    @ranges = @intervals.each_cons(2).to_a.map{|start,finish|
      {
        from:   start,
        to:     finish,
      }
    }
    
    @query = {
      size: 0,
      aggs: {
        group_by_derived_tstamp: {
          range: {
            field:    'derived_tstamp',
            ranges:   @ranges
          },
          aggs: {
            events: {
              terms:  {
                field:  'page_url',
              },
            },
          },
        }
      }
    }
  end
  
  def extract_page_views_results(data = @data)
    histograms = []
    
    aggregations = data['aggregations']
    
    if aggregations
      
      group_by_derived_tstamp = aggregations['group_by_derived_tstamp']
      
      if group_by_derived_tstamp
        buckets = group_by_derived_tstamp['buckets']
        
        buckets.each do |bucket|
          date_from = Time.parse(bucket['from_as_string'])
          
          histogram = {}
          histogram.default = 0
          
          bucket['events']['buckets'].each do |event_bucket|
            histogram[event_bucket['key']] = event_bucket['doc_count'].to_i
          end
          
          histograms << [
            bucket['from_as_string'],
            bucket['to_as_string'],
            histogram,
          ]
        end
      else
        Rails.logger.error 'NO GROUP_BY_DERIVED_TSTAMP'
      end
    else
      Rails.logger.error 'NO AGGREGATIONS'
    end
    
    @results = histograms
  end
  
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
