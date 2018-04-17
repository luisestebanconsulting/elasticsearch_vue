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
      assert_assigns :results, [
        [
          '2017-05-31T14:00:00.000Z', '2017-11-27T14:00:00.000Z', {
            'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>178373,
            'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615'=>143038,
            'http://www.news.com.au/sport/afl/port-adelaide/shocking-moment-opens-port-adelaidehawthorn/news-story/10e3565c416940c370cd2cdd2a56e24b'=>141330,
            'http://www.smh.com.au/nsw/premier-gladys-berejiklian-announces-housing-affordability-reforms-20170601-gwi0jn.html'=>120438,
            'http://www.theage.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>118454,
            'http://www.news.com.au/travel/travel-advice/flights/qantas-cabin-crew-reveal-the-secrets-of-a-long-haul-flight-in-new-documentary/news-story/2435b8fb4b7a8c65d1f2f3f7cece7899'=>114678,
            'http://www.news.com.au/technology/environment/trump-pulls-us-out-of-paris-climate-agreement/news-story/f5c30a07c595a10a81d67611d0515a0a'=>111732,
            'http://www.news.com.au/world/north-america/twitter-fail-as-world-asks-trump-what-the-hell-does-covfefe-mean/news-story/a336a6109dfdb363681545c8d9a725e1'=>106961,
            'http://www.news.com.au/finance/economy/australian-economy/is-australia-heading-towards-the-economic-collapse-were-due-to-have/news-story/a160068d3eed73cc3f86eb639a322b4c'=>105441,
            'http://www.news.com.au/travel/travel-updates/incidents/malaysia-airlines-flight-mh-128-returns-to-melbourne-after-incident-on-plane/news-story/8b6f36d08bf5f11567665235e0066ed1'=>101516
          }
        ]
      ]
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
    assert_assigns :results, [
      [
        '2017-05-31T14:00:00.000Z', '2017-05-31T16:00:00.000Z',
        {
          'http://www.news.com.au/sport/nrl/state-of-origin-game-1-at-suncorp-stadium-live-updates/news-story/268c4847daa63429a986602c15b3cc3e'=>22,
          'http://www.news.com.au/world/africa/hannah-cornelius-murder-it-seems-they-just-wanted-to-kill/news-story/853bac5df593b5aa102fded7c950fd53'=>21,
          'http://www.news.com.au/travel/travel-updates/incidents/malaysia-airlines-flight-mh-128-returns-to-melbourne-after-incident-on-plane/news-story/8b6f36d08bf5f11567665235e0066ed1'=>17,
          'http://www.news.com.au/world/north-america/twitter-fail-as-world-asks-trump-what-the-hell-does-covfefe-mean/news-story/a336a6109dfdb363681545c8d9a725e1'=>16,
          'http://www.news.com.au/lifestyle/real-life/news-life/car-sticker-gets-people-fired-up-about-slow-left-hand-lane-drivers-all-over-again/news-story/d76a195c9ba4f337500080bcfeb6b922'=>14,
          'http://www.theage.com.au/victoria/box-hill-hospital-employee-in-critical-condition-after-serious-assault-20170531-gwgz8g.html'=>10,
          'http://www.news.com.au/finance/real-estate/buying/felicia-coco-shares-her-secret-on-how-she-could-afford-to-buy-a-home-at-22/news-story/ef012f0f0d93179bc0746cadffe66140'=>8,
          'http://www.news.com.au/finance/work/at-work/a-model-alleges-she-was-sacked-when-working-for-hyundai-as-she-had-her-period/news-story/fa42d0dd022b8730c52cf44b37aa85f4'=>8,
          'http://www.news.com.au/lifestyle/parenting/babies/the-incredible-moment-newborn-stuns-midwives-as-she-starts-walking-minutes-after-being-born/news-story/6007926fbd2b1e225d18f20cae04dee7'=>8,
          'http://www.news.com.au/travel/travel-updates/incidents/malaysia-airlines-flight-mh-128-returns-to-melbourne-after-incident-on-plane/news-story/8b6f36d08bf5f11567665235e0066ed1?utm_content=SocialFlow&utm_campaign=EditorialSF&utm_source=News.com.au&utm_medium=Facebook'=>7
        }
      ],
      [
        '2017-05-31T16:00:00.000Z', '2017-05-31T18:00:00.000Z',
        {
          'http://www.news.com.au/travel/travel-updates/incidents/malaysia-airlines-flight-mh-128-returns-to-melbourne-after-incident-on-plane/news-story/8b6f36d08bf5f11567665235e0066ed1'=>40,
          'http://www.smh.com.au/national/malaysia-airlines-flight-turns-back-to-melbourne-after-passenger-tried-to-enter-cockpit-20170531-gwho8x.html'=>23,
          'http://www.ntnews.com.au/sport/football/steven-gerrard-turns-back-clock-with-combative-performance-as-liverpool-comfortably-take-down-sydney-fc/news-story/46bdd3f9d6bca8c2b4ed9b4a941dfe35'=>15,
          'http://www.theage.com.au/national/malaysia-airlines-flight-turns-back-to-melbourne-after-passenger-tried-to-enter-cockpit-20170531-gwho8x.html'=>15,
          'http://www.ntnews.com.au/news/national/man-accused-of-raping-expartners-intellectually-disabled-daughter/news-story/7339c1af4fa04109d3d6d9f9824d5f23'=>14,
          'http://www.news.com.au/sport/nrl/state-of-origin-game-1-at-suncorp-stadium-live-updates/news-story/268c4847daa63429a986602c15b3cc3e'=>13,
          'http://www.news.com.au/world/africa/hannah-cornelius-murder-it-seems-they-just-wanted-to-kill/news-story/853bac5df593b5aa102fded7c950fd53'=>13,
          'http://www.ntnews.com.au/entertainment/music/ariana-grande-cancels-multiple-concerts-following-manchester-attack/news-story/18b2b104967869c9c5f295f533c50ddd'=>11,
          'http://www.ntnews.com.au/sport/tennis/nick-kyrgios-slips-out-of-top-16-seeded-players-for-french-open/news-story/41caf4563c2ddaa117f9750b02511f8d'=>11,
          'http://www.ntnews.com.au/news/breaking-news/trump-not-tracking-all-foreign-profits/news-story/f693a929f8f06af9e8c1c4f8bb9f3a9c'=>10
        }
      ],
      [
        '2017-05-31T18:00:00.000Z', '2017-05-31T20:00:00.000Z',
        {
          'http://www.news.com.au/sport/nrl/state-of-origin-game-1-at-suncorp-stadium-live-updates/news-story/268c4847daa63429a986602c15b3cc3e'=>36,
          'http://www.news.com.au/world/africa/hannah-cornelius-murder-it-seems-they-just-wanted-to-kill/news-story/853bac5df593b5aa102fded7c950fd53'=>24,
          'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615'=>21,
          'http://www.smh.com.au/national/malaysia-airlines-flight-turns-back-to-melbourne-after-passenger-tried-to-enter-cockpit-20170531-gwho8x.html'=>19,
          'http://www.news.com.au/world/asia/north-korea-is-missile-war-on-the-cards-or-does-kim-jongun-have-other-plans/news-story/75dc821899651c38c4615af1aea8bce6'=>14,
          'http://www.news.com.au/lifestyle/real-life/news-life/car-sticker-gets-people-fired-up-about-slow-left-hand-lane-drivers-all-over-again/news-story/d76a195c9ba4f337500080bcfeb6b922'=>13,
          'http://www.news.com.au/travel/travel-updates/incidents/malaysia-airlines-flight-mh-128-returns-to-melbourne-after-incident-on-plane/news-story/8b6f36d08bf5f11567665235e0066ed1'=>12,
          'http://www.smh.com.au/rugby-league/league-match-report/state-of-origin-2017-andrew-fifita-produces-performance-for-the-ages-in-nsw-blues-win-20170531-gwh3wj.html'=>12,
          'http://www.news.com.au/world/north-america/twitter-fail-as-world-asks-trump-what-the-hell-does-covfefe-mean/news-story/a336a6109dfdb363681545c8d9a725e1'=>11,
          'http://www.theage.com.au/national/malaysia-airlines-flight-turns-back-to-melbourne-after-passenger-tried-to-enter-cockpit-20170531-gwho8x.html'=>11
        }
      ],
      [
        '2017-05-31T20:00:00.000Z', '2017-05-31T22:00:00.000Z',
        {
          'http://www.news.com.au/sport/nrl/state-of-origin-game-1-at-suncorp-stadium-live-updates/news-story/268c4847daa63429a986602c15b3cc3e'=>116,
          'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615'=>115,
          'http://www.news.com.au/world/africa/hannah-cornelius-murder-it-seems-they-just-wanted-to-kill/news-story/853bac5df593b5aa102fded7c950fd53'=>62,
          'http://www.theage.com.au/business/aviation/malaysia-airlines-flight-turns-back-to-melbourne-after-passenger-tried-to-enter-cockpit-20170531-gwho8x.html'=>62,
          'http://www.smh.com.au/business/aviation/malaysia-airlines-flight-turns-back-to-melbourne-after-passenger-tried-to-enter-cockpit-20170531-gwho8x.html'=>57,
          'http://www.news.com.au/world/asia/north-korea-is-missile-war-on-the-cards-or-does-kim-jongun-have-other-plans/news-story/75dc821899651c38c4615af1aea8bce6'=>51,
          'http://www.news.com.au/lifestyle/real-life/news-life/car-sticker-gets-people-fired-up-about-slow-left-hand-lane-drivers-all-over-again/news-story/d76a195c9ba4f337500080bcfeb6b922'=>46,
          'http://www.news.com.au/world/north-america/twitter-fail-as-world-asks-trump-what-the-hell-does-covfefe-mean/news-story/a336a6109dfdb363681545c8d9a725e1'=>38,
          'http://www.news.com.au/finance/work/at-work/a-model-alleges-she-was-sacked-when-working-for-hyundai-as-she-had-her-period/news-story/fa42d0dd022b8730c52cf44b37aa85f4'=>33,
          'http://www.smh.com.au/world/paris-climate-deal-elon-musk-threatens-to-quit-donald-trumps-advisory-council-20170531-gwhoym.html'=>30
        }
      ],
      [
        '2017-05-31T22:00:00.000Z', '2017-06-01T00:00:00.000Z',
        {
          'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615'=>219,
          'http://www.news.com.au/world/africa/hannah-cornelius-murder-it-seems-they-just-wanted-to-kill/news-story/853bac5df593b5aa102fded7c950fd53'=>169,
          'http://www.news.com.au/lifestyle/real-life/news-life/car-sticker-gets-people-fired-up-about-slow-left-hand-lane-drivers-all-over-again/news-story/d76a195c9ba4f337500080bcfeb6b922'=>103,
          'http://www.news.com.au/sport/nrl/origin/player-ratings-for-state-of-origin-2017-game-1/news-story/2f00a345f3ab03962d8bcd3a807064e5'=>103,
          'http://www.smh.com.au/nsw/sydney-bus-passengers-travel-for-free-as-drivers-declare-fare-free-day-20170531-gwhpo9.html'=>103,
          'http://www.news.com.au/national/rush-hour/rush-hour-the-stories-you-need-to-know-today/news-story/3f2e753cb37c690399fb250be1f66464'=>98,
          'http://www.news.com.au/sport/nrl/state-of-origin-game-1-at-suncorp-stadium-live-updates/news-story/268c4847daa63429a986602c15b3cc3e'=>97,
          'http://www.smh.com.au/business/aviation/malaysia-airlines-flight-turns-back-to-melbourne-after-passenger-tried-to-enter-cockpit-20170531-gwho8x.html'=>89,
          'http://www.news.com.au/travel/travel-updates/incidents/malaysia-airlines-flight-mh-128-returns-to-melbourne-after-incident-on-plane/news-story/8b6f36d08bf5f11567665235e0066ed1'=>85,
          'http://www.smh.com.au/world/paris-climate-deal-elon-musk-threatens-to-quit-donald-trumps-advisory-council-20170531-gwhoym.html'=>85
        }
      ],
      [
        '2017-06-01T00:00:00.000Z', '2017-06-01T02:00:00.000Z',
        {
          'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615'=>32941,
          'http://www.news.com.au/travel/travel-updates/incidents/malaysia-airlines-flight-mh-128-returns-to-melbourne-after-incident-on-plane/news-story/8b6f36d08bf5f11567665235e0066ed1'=>28100,
          'http://www.news.com.au/sport/american-sports/nba/lavar-ball-reportedly-cost-his-son-lonzo-a-massive-payday/news-story/0c764465485a9847bd65727a963909bf'=>27764,
          'http://www.news.com.au/entertainment/movies/upcoming-movies/film-company-apologises-for-fatshaming-snow-white/news-story/d0a2c8854b7bf9e2289488fcc352f4af'=>23511,
          'http://www.news.com.au/world/africa/hannah-cornelius-murder-it-seems-they-just-wanted-to-kill/news-story/853bac5df593b5aa102fded7c950fd53'=>21407,
          'http://www.news.com.au/lifestyle/real-life/news-life/car-sticker-gets-people-fired-up-about-slow-left-hand-lane-drivers-all-over-again/news-story/d76a195c9ba4f337500080bcfeb6b922'=>17473,
          'http://www.news.com.au/finance/economy/australian-economy/capital-city-house-prices-fall-11-per-cent-in-may/news-story/1673b01639bb27d8783c01113babb158'=>15377,
          'http://www.smh.com.au/nsw/top-cop-alerted-to-rising-tensions-between-neighbours-on-sydneys-scotland-island-20170531-gwh4vi.html'=>15011,
          'http://www.news.com.au/entertainment/tv/morning-shows/karl-mocks-nines-underwhelming-royal-scoop/news-story/7f93707202f31f759145a37748bec837'=>13578,
          'http://www.news.com.au/sport/nrl/origin/player-ratings-for-state-of-origin-2017-game-1/news-story/2f00a345f3ab03962d8bcd3a807064e5'=>12045
        }
      ],
      [
        '2017-06-01T02:00:00.000Z', '2017-06-01T04:00:00.000Z',
        {
          'http://www.news.com.au/travel/travel-updates/incidents/disruptive-passenger-grounds-flight-after-storming-cockpit/news-story/5949c1e9542df41fb89e6cdcdc16b615'=>55734,
          'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>41532,
          'http://www.news.com.au/lifestyle/real-life/news-life/viral-video-shows-halfnaked-model-fighting-with-man-she-claims-groped-her/news-story/b38d511b7dda6c6bf23aecb4e6e341b3'=>36051,
          'http://www.news.com.au/sport/nrl/nrl-legends-tee-off-on-queensland-origin-dilemma-nsws-invisible-warrior/news-story/2098bd3d51ac5985969a9111a3518b86'=>31948,
          'http://www.news.com.au/finance/economy/australian-economy/capital-city-house-prices-fall-11-per-cent-in-may/news-story/1673b01639bb27d8783c01113babb158'=>28498,
          'http://www.news.com.au/lifestyle/beauty/cosmetic-surgery/model-spends-240000-on-surgery-to-look-like-kim-kardashian/news-story/f43dc1d05d14c638e36839894a2bda02'=>24034,
          'http://www.news.com.au/entertainment/celebrity-life/celebrity-selfies/schapelle-corbys-instagram-game-is-strong-and-shell-reply-to-your-questions/news-story/70ad01aa1b52946aad75aafdfe0b6bad'=>23890,
          'http://www.news.com.au/travel/travel-updates/incidents/malaysia-airlines-flight-mh-128-returns-to-melbourne-after-incident-on-plane/news-story/8b6f36d08bf5f11567665235e0066ed1'=>22745,
          'http://www.theage.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>22139,
          'http://www.news.com.au/finance/work/leaders/billionaires-threat-to-trump-leave-paris-and-im-out/news-story/384da13c30b7809477e28dc74e023b6a'=>20601
        }
      ],
      [
        '2017-06-01T04:00:00.000Z', '2017-06-01T06:00:00.000Z',
        {
          'http://www.smh.com.au/nsw/premier-gladys-berejiklian-announces-housing-affordability-reforms-20170601-gwi0jn.html'=>43685,
          'http://www.news.com.au/finance/economy/australian-economy/is-australia-heading-towards-the-economic-collapse-were-due-to-have/news-story/a160068d3eed73cc3f86eb639a322b4c'=>40043,
          'http://www.news.com.au/finance/money/wealth/its-just-surreal-mystery-solved-as-young-cairns-mother-wins-40-million-in-oz-lotto/news-story/65a51676d207a5470fa9301dbba658b6'=>35218,
          'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>30457,
          'http://www.news.com.au/finance/work/leaders/billionaires-threat-to-trump-leave-paris-and-im-out/news-story/384da13c30b7809477e28dc74e023b6a'=>28994,
          'http://www.theage.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>22874,
          'http://www.news.com.au/lifestyle/beauty/cosmetic-surgery/model-spends-240000-on-surgery-to-look-like-kim-kardashian/news-story/f43dc1d05d14c638e36839894a2bda02'=>22444,
          'http://www.couriermail.com.au/news/queensland/the-wife-of-slain-policeman-brett-forte-has-been-tormented-outside-toowoomba-police-station/news-story/75e376c3836cea1f00850b4f9559f491'=>17863,
          'http://www.news.com.au/finance/economy/australian-economy/capital-city-house-prices-fall-11-per-cent-in-may/news-story/1673b01639bb27d8783c01113babb158'=>17694,
          'http://www.news.com.au/travel/travel-advice/flights/qantas-cabin-crew-reveal-the-secrets-of-a-long-haul-flight-in-new-documentary/news-story/2435b8fb4b7a8c65d1f2f3f7cece7899'=>16741
        }
      ],
      [
        '2017-06-01T06:00:00.000Z', '2017-06-01T08:00:00.000Z',
        {
          'http://www.news.com.au/world/north-america/twitter-fail-as-world-asks-trump-what-the-hell-does-covfefe-mean/news-story/a336a6109dfdb363681545c8d9a725e1'=>34875,
          'http://www.news.com.au/finance/economy/australian-economy/is-australia-heading-towards-the-economic-collapse-were-due-to-have/news-story/a160068d3eed73cc3f86eb639a322b4c'=>30273,
          'http://www.news.com.au/travel/travel-advice/flights/qantas-cabin-crew-reveal-the-secrets-of-a-long-haul-flight-in-new-documentary/news-story/2435b8fb4b7a8c65d1f2f3f7cece7899'=>28058,
          'http://www.smh.com.au/nsw/premier-gladys-berejiklian-announces-housing-affordability-reforms-20170601-gwi0jn.html'=>25525,
          'http://www.news.com.au/finance/work/at-work/australia-post-courier-says-drivers-are-forced-to-cut-corners-to-meet-impossible-parcel-delivery-quotas/news-story/793003fd2f16df79864c3977a570af77'=>25183,
          'http://www.news.com.au/finance/business/retail/tacos-are-now-australias-favourite-cookathome-meal/news-story/64f719b948a809887623161144c530cc'=>22919,
          'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>21767,
          'http://www.news.com.au/finance/money/wealth/its-just-surreal-mystery-solved-as-young-cairns-mother-wins-40-million-in-oz-lotto/news-story/65a51676d207a5470fa9301dbba658b6'=>20158,
          'http://www.smh.com.au/rugby-league/league-news/state-of-origin-2017-nsw-players-ill-in-silence-after-crazy-first-half-20170601-gwi0hl.html'=>17411,
          'http://www.theage.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>17361
        }
      ],
      [
        '2017-06-01T08:00:00.000Z', '2017-06-01T10:00:00.000Z',
        {
          'http://www.news.com.au/finance/work/at-work/australia-post-courier-says-drivers-are-forced-to-cut-corners-to-meet-impossible-parcel-delivery-quotas/news-story/793003fd2f16df79864c3977a570af77'=>32489,
          'http://www.news.com.au/world/north-america/twitter-fail-as-world-asks-trump-what-the-hell-does-covfefe-mean/news-story/a336a6109dfdb363681545c8d9a725e1'=>22552,
          'http://www.news.com.au/travel/travel-advice/flights/qantas-cabin-crew-reveal-the-secrets-of-a-long-haul-flight-in-new-documentary/news-story/2435b8fb4b7a8c65d1f2f3f7cece7899'=>19852,
          'http://www.news.com.au/lifestyle/parenting/school-life/this-mother-found-her-daughters-homework-horribly-outdated-so-she-amended-it/news-story/5ec0a76887a20050e475a9e55880084c'=>19632,
          'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>18298,
          'http://www.news.com.au/finance/economy/australian-economy/is-australia-heading-towards-the-economic-collapse-were-due-to-have/news-story/a160068d3eed73cc3f86eb639a322b4c'=>18062,
          'http://www.smh.com.au/nsw/director-of-public-prosecutions-to-appeal-luke-lazarus-acquittal-20170601-gwifhs.html'=>16462,
          'http://www.smh.com.au/nsw/premier-gladys-berejiklian-announces-housing-affordability-reforms-20170601-gwi0jn.html'=>15419,
          'http://www.news.com.au/lifestyle/parenting/kids/mum-horrified-by-disgusting-discovery-at-kids-play-centre-in-melbourne/news-story/b9cc5e7392a128b7172e2ca9207b6e04'=>15408,
          'http://www.theage.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>14464
        }
      ],
      [
        '2017-06-01T10:00:00.000Z', '2017-06-01T12:00:00.000Z',
        {
          'http://www.news.com.au/finance/business/other-industries/international-whores-day-to-be-marked-in-sydney/news-story/cde6b74bcdaf71bb9c16521fea39a474'=>30241,
          'http://www.news.com.au/lifestyle/real-life/lisa-roussos-learns-of-daughter-saffies-death-after-coming-off-life-support-family-friend-says/news-story/9cba9550065531e8f72fd04bf2c85989'=>22613,
          'http://www.news.com.au/world/north-america/twitter-fail-as-world-asks-trump-what-the-hell-does-covfefe-mean/news-story/a336a6109dfdb363681545c8d9a725e1'=>18923,
          'http://www.news.com.au/travel/travel-updates/incidents/how-rogue-passengers-are-still-evading-security-to-threaten-flights/news-story/796a1153d972d05b46d1bcc98be8d1f4'=>18358,
          'http://www.news.com.au/national/queensland/news/the-wife-of-slain-policeman-brett-forte-has-been-tormented-outside-toowoomba-police-station/news-story/442628661084299ebe3c76e00accf7a3'=>17127,
          'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>16613,
          'http://www.news.com.au/travel/travel-advice/flights/qantas-cabin-crew-reveal-the-secrets-of-a-long-haul-flight-in-new-documentary/news-story/2435b8fb4b7a8c65d1f2f3f7cece7899'=>15918,
          'http://www.news.com.au/lifestyle/parenting/school-life/this-mother-found-her-daughters-homework-horribly-outdated-so-she-amended-it/news-story/5ec0a76887a20050e475a9e55880084c'=>15869,
          'http://www.smh.com.au/nsw/director-of-public-prosecutions-to-appeal-luke-lazarus-acquittal-20170601-gwifhs.html'=>13838,
          'http://www.theage.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>13295
        }
      ],
      [
        '2017-06-01T12:00:00.000Z', '2017-06-01T14:00:00.000Z',
        {
          'http://www.news.com.au/sport/afl/port-adelaide/shocking-moment-opens-port-adelaidehawthorn/news-story/10e3565c416940c370cd2cdd2a56e24b'=>35199,
          'http://www.news.com.au/lifestyle/real-life/lisa-roussos-learns-of-daughter-saffies-death-after-coming-off-life-support-family-friend-says/news-story/9cba9550065531e8f72fd04bf2c85989'=>20402,
          'http://www.news.com.au/sport/sports-life/cate-mcgregor-delivers-moving-response-to-margaret-courts-comments-on-lesbians-and-transgender-children/news-story/6c24e944bde9d4ce1cacc5385a214348'=>17064,
          'http://www.news.com.au/lifestyle/food/choice-makes-weighty-argument-to-leave-food-labelling-alone/news-story/db224437f0def64f550c77d5c0445359'=>15791,
          'http://www.news.com.au/finance/business/other-industries/international-whores-day-to-be-marked-in-sydney/news-story/cde6b74bcdaf71bb9c16521fea39a474'=>13957,
          'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>13164,
          'http://www.news.com.au/world/north-america/twitter-fail-as-world-asks-trump-what-the-hell-does-covfefe-mean/news-story/a336a6109dfdb363681545c8d9a725e1'=>10106,
          'http://www.news.com.au/travel/travel-advice/flights/qantas-cabin-crew-reveal-the-secrets-of-a-long-haul-flight-in-new-documentary/news-story/2435b8fb4b7a8c65d1f2f3f7cece7899'=>10083,
          'http://www.news.com.au/entertainment/celebrity-life/hook-ups-break-ups/jennifer-garner-i-want-to-set-the-record-straight/news-story/598ab8d733bad28e79ba086153b6cbf5'=>9804,
          'http://www.news.com.au/sport/nrl/gorden-tallis-reignites-feud-with-robbie-farah/news-story/81f25ae67871d8c5f201cc8038caca2d'=>9641
        }
      ],
      [
        '2017-06-01T14:00:00.000Z', '2017-06-01T16:00:00.000Z',
        {
          'http://www.news.com.au/technology/science/evolution/the-scary-future-predictions-we-cant-ignore/news-story/3a4882ae3a70dffa7ce74bb9d968778e'=>10771,
          'http://www.news.com.au/lifestyle/food/choice-makes-weighty-argument-to-leave-food-labelling-alone/news-story/db224437f0def64f550c77d5c0445359'=>7980,
          'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>7934,
          'http://www.news.com.au/sport/afl/port-adelaide/shocking-moment-opens-port-adelaidehawthorn/news-story/10e3565c416940c370cd2cdd2a56e24b'=>5844,
          'http://www.news.com.au/lifestyle/real-life/lisa-roussos-learns-of-daughter-saffies-death-after-coming-off-life-support-family-friend-says/news-story/9cba9550065531e8f72fd04bf2c85989'=>5788,
          'http://www.news.com.au/entertainment/movies/new-movies/robert-pattinson-was-surviving-on-tinned-tuna-and-living-in-a-basement/news-story/28a68049e28fc615541a83a3d59a2b3d'=>4420,
          'http://www.news.com.au/sport/sports-life/cate-mcgregor-delivers-moving-response-to-margaret-courts-comments-on-lesbians-and-transgender-children/news-story/6c24e944bde9d4ce1cacc5385a214348'=>3901,
          'http://www.news.com.au/finance/business/other-industries/international-whores-day-to-be-marked-in-sydney/news-story/cde6b74bcdaf71bb9c16521fea39a474'=>3851,
          'http://www.smh.com.au/nsw/bones-believed-to-belong-to-matthew-leveson-exhumed-from-burial-site-20170601-gwibni.html'=>3618,
          'http://www.theage.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>3313
        }
      ],
      [
        '2017-06-01T16:00:00.000Z', '2017-06-01T18:00:00.000Z',
        {
          'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>6824,
          'http://www.news.com.au/technology/science/evolution/the-scary-future-predictions-we-cant-ignore/news-story/3a4882ae3a70dffa7ce74bb9d968778e'=>5728,
          'http://www.news.com.au/lifestyle/food/choice-makes-weighty-argument-to-leave-food-labelling-alone/news-story/db224437f0def64f550c77d5c0445359'=>4341,
          'http://www.news.com.au/lifestyle/real-life/lisa-roussos-learns-of-daughter-saffies-death-after-coming-off-life-support-family-friend-says/news-story/9cba9550065531e8f72fd04bf2c85989'=>3171,
          'http://www.news.com.au/sport/afl/port-adelaide/shocking-moment-opens-port-adelaidehawthorn/news-story/10e3565c416940c370cd2cdd2a56e24b'=>2837,
          'http://www.news.com.au/finance/real-estate/buying/barack-and-michelle-obama-buy-amazing-11m-home-in-kalorama-washington-dc/news-story/e67a9952fc2116689c51906afd91a326'=>2421,
          'http://www.news.com.au/entertainment/movies/new-movies/robert-pattinson-was-surviving-on-tinned-tuna-and-living-in-a-basement/news-story/28a68049e28fc615541a83a3d59a2b3d'=>2386,
          'http://www.smh.com.au/nsw/bones-believed-to-belong-to-matthew-leveson-exhumed-from-burial-site-20170601-gwibni.html'=>2200,
          'http://www.theage.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>2144,
          'http://www.news.com.au/sport/tennis/kyrgios-beer-broken-racquets-meltdown-as-he-loses-in-second-round-of-french-open-to-kevin-anderson/news-story/ab519962b085a0ffd5255cb4acb6b639'=>2119
        }
      ],
      [
        '2017-06-01T18:00:00.000Z', '2017-06-01T20:00:00.000Z',
        {
          'http://www.news.com.au/technology/science/evolution/the-scary-future-predictions-we-cant-ignore/news-story/3a4882ae3a70dffa7ce74bb9d968778e'=>12359,
          'http://www.news.com.au/world/asia/islamic-state-gunmen-storm-manila-hotel-leaving-several-people-injured/news-story/a915b8a2d4f9658f45e89c8427530e6a'=>11032,
          'http://www.news.com.au/lifestyle/food/choice-makes-weighty-argument-to-leave-food-labelling-alone/news-story/db224437f0def64f550c77d5c0445359'=>8931,
          'http://www.news.com.au/sport/afl/port-adelaide/shocking-moment-opens-port-adelaidehawthorn/news-story/10e3565c416940c370cd2cdd2a56e24b'=>6766,
          'http://www.smh.com.au/world/gunfire-explosions-heard-outside-resorts-world-in-manila-philippines-20170601-gwioey.html'=>6502,
          'http://www.smh.com.au/nsw/bones-believed-to-belong-to-matthew-leveson-exhumed-from-burial-site-20170601-gwibni.html'=>6403,
          'http://www.news.com.au/lifestyle/real-life/lisa-roussos-learns-of-daughter-saffies-death-after-coming-off-life-support-family-friend-says/news-story/9cba9550065531e8f72fd04bf2c85989'=>5923,
          'http://www.smh.com.au/sport/tennis/an-open-letter-from-martina-navratilova-to-margaret-court-arena-20170601-gwhuyx.html'=>5823,
          'http://www.news.com.au/finance/real-estate/buying/barack-and-michelle-obama-buy-amazing-11m-home-in-kalorama-washington-dc/news-story/e67a9952fc2116689c51906afd91a326'=>4721,
          'http://www.news.com.au/finance/business/other-industries/international-whores-day-to-be-marked-in-sydney/news-story/cde6b74bcdaf71bb9c16521fea39a474'=>4490
        }
      ],
      [
        '2017-06-01T20:00:00.000Z', '2017-06-01T22:00:00.000Z',
        {
          'http://www.news.com.au/technology/environment/trump-pulls-us-out-of-paris-climate-agreement/news-story/f5c30a07c595a10a81d67611d0515a0a'=>55709,
          'http://www.news.com.au/sport/afl/port-adelaide/shocking-moment-opens-port-adelaidehawthorn/news-story/10e3565c416940c370cd2cdd2a56e24b'=>43503,
          'http://www.news.com.au/lifestyle/food/choice-makes-weighty-argument-to-leave-food-labelling-alone/news-story/db224437f0def64f550c77d5c0445359'=>33406,
          'http://www.news.com.au/world/asia/manila-hotel-on-lockdown-after-islamic-state-gunmen-opened-fire-on-tourists/news-story/6d3fe632beaf774da016458d92e61254'=>31638,
          'http://www.smh.com.au/world/paris-climate-deal-donald-trump-withdraws-us-from-the-accord-20170601-gwiord.html'=>23639,
          'http://www.news.com.au/technology/science/evolution/the-scary-future-predictions-we-cant-ignore/news-story/3a4882ae3a70dffa7ce74bb9d968778e'=>21063,
          'http://www.news.com.au/world/asia/islamic-state-gunmen-storm-manila-hotel-leaving-several-people-injured/news-story/a915b8a2d4f9658f45e89c8427530e6a'=>16471,
          'http://www.news.com.au/national/rush-hour/rush-hour-the-stories-you-need-to-know-today/news-story/9a1e35a7b66a8bc6886abaa5719d151e'=>16379,
          'http://www.smh.com.au/environment/climate-change/donald-trumps-call-to-put-america-first-by-exiting-paris-climate-accord-to-backfire-20170601-gwiofc.html'=>16172,
          'http://www.smh.com.au/nsw/bones-believed-to-belong-to-matthew-leveson-exhumed-from-burial-site-20170601-gwibni.html'=>15086
        }
      ],
      [
        '2017-06-01T22:00:00.000Z', '2017-06-02T00:00:00.000Z',
        {
          'http://www.news.com.au/technology/environment/trump-pulls-us-out-of-paris-climate-agreement/news-story/f5c30a07c595a10a81d67611d0515a0a'=>54047,
          'http://www.news.com.au/entertainment/tv/morning-shows/karl-slams-sleazy-article-about-female-colleague-in-emotional-speech/news-story/53d4d8f16f17520c38eea23d0692039b'=>48339,
          'http://www.news.com.au/sport/afl/port-adelaide/shocking-moment-opens-port-adelaidehawthorn/news-story/10e3565c416940c370cd2cdd2a56e24b'=>38698,
          'http://www.news.com.au/world/asia/manila-hotel-on-lockdown-after-islamic-state-gunmen-opened-fire-on-tourists/news-story/6d3fe632beaf774da016458d92e61254'=>30705,
          'http://www.news.com.au/lifestyle/food/choice-makes-weighty-argument-to-leave-food-labelling-alone/news-story/db224437f0def64f550c77d5c0445359'=>28021,
          'http://www.smh.com.au/world/world-leaders-react-as-donald-trump-withdraws-us-from-paris-climate-deal-20170601-gwiphv.html'=>26574,
          'http://www.news.com.au/national/rush-hour/rush-hour-the-stories-you-need-to-know-today/news-story/9a1e35a7b66a8bc6886abaa5719d151e'=>24208,
          'http://www.news.com.au/sport/nrl/ben-ikin-and-gorden-tallis-add-names-calling-for-queensland-ditch-duds/news-story/b45d6e9d99e7e6bbe4cd6c75bb1bcfdc'=>14889,
          'http://www.smh.com.au/entertainment/tv-and-radio/a-long-track-record-of-denigrating-women-karl-loses-it-at-daily-mail-20170601-gwipwq.html'=>13529,
          'http://www.news.com.au/technology/science/evolution/the-scary-future-predictions-we-cant-ignore/news-story/3a4882ae3a70dffa7ce74bb9d968778e'=>13025
        }
      ],
      ['2017-06-02T00:00:00.000Z', '2017-06-02T02:00:00.000Z', {}],
      ['2017-06-02T02:00:00.000Z', '2017-06-02T04:00:00.000Z', {}],
      ['2017-06-02T04:00:00.000Z', '2017-06-02T06:00:00.000Z', {}],
      ['2017-06-02T06:00:00.000Z', '2017-06-02T08:00:00.000Z', {}],
      ['2017-06-02T08:00:00.000Z', '2017-06-02T10:00:00.000Z', {}],
      ['2017-06-02T10:00:00.000Z', '2017-06-02T12:00:00.000Z', {}],
      ['2017-06-02T12:00:00.000Z', '2017-06-02T14:00:00.000Z', {}],
      ['2017-06-02T14:00:00.000Z', '2017-06-02T16:00:00.000Z', {}],
      ['2017-06-02T16:00:00.000Z', '2017-06-02T18:00:00.000Z', {}],
      ['2017-06-02T18:00:00.000Z', '2017-06-02T20:00:00.000Z', {}],
      ['2017-06-02T20:00:00.000Z', '2017-06-02T22:00:00.000Z', {}],
      ['2017-06-02T22:00:00.000Z', '2017-06-03T00:00:00.000Z', {}],
      ['2017-06-03T00:00:00.000Z', '2017-06-03T02:00:00.000Z', {}],
      ['2017-06-03T02:00:00.000Z', '2017-06-03T04:00:00.000Z', {}],
      ['2017-06-03T04:00:00.000Z', '2017-06-03T06:00:00.000Z', {}],
      ['2017-06-03T06:00:00.000Z', '2017-06-03T08:00:00.000Z', {}],
      ['2017-06-03T08:00:00.000Z', '2017-06-03T10:00:00.000Z', {}],
      ['2017-06-03T10:00:00.000Z', '2017-06-03T12:00:00.000Z', {}],
      ['2017-06-03T12:00:00.000Z', '2017-06-03T14:00:00.000Z', {}]]
  end
  
end
