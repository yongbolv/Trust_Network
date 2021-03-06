# t.string   "block",      limit: 255
# t.string   "currency",   limit: 255
# t.string   "title",      limit: 255
# t.datetime "created_at",             null: false
# t.datetime "updated_at",             null: false

class Chain < ActiveRecord::Base

  validates_presence_of :block, :currency, :title
  validates_uniqueness_of :block, scope: :currency
  has_many :markets, class_name:'Market'
  has_many :day_bars, class_name:'DayBar'
  has_many :min30_indicators, class_name:'Min30Indicator'

  def market_name
    "#{self.currency}-#{self.block}"
  end

  def get_market
    market_url = 'https://bittrex.com/api/v1.1/public/getmarketsummary'
    res = Faraday.get do |req|
      req.url market_url
      req.params['market'] = self.market_name
    end
    current = JSON.parse(res.body)
    current['result']
  end

  def get_day_tick
    market_url = 'https://bittrex.com/Api/v2.0/pub/market/GetTicks'
    res = Faraday.get do |req|
      req.url market_url
      req.params['marketName'] = self.market_name
      req.params['tickInterval'] = 'day'
    end
    current = JSON.parse(res.body)
    current['result']
  end

  def tick

  end

end
