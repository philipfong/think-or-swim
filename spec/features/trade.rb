require 'spec_helper'

feature "Trade on etrade" do

  scenario "Buy and sell SPY" do
    visit 'http://www.etrade.com'
    sleep 20 # Log in, open a new tab and visit another site like Gmail
    Log.info 'About to launch trading portal in 10 seconds'
    sleep 10
    @win = window_opened_by do
      find('.tiny-header', :text => 'Paper Trading').find(:xpath, '..').click_button('Launch')
    end
    stonk = Stonk.new
    within_window @win do
      initiate_trading(stonk)
    end
  end

end

def initiate_trading(stonk)
  stonk.get_base_price
  stonk.last_known_price = stonk.base_price
  while true
    stonk.get_updated_price
    if stonk.price_changed?
      stonk.track_deltas
      stonk.set_price_targets
    end
    stonk.last_known_price = stonk.updated_price
    stonk.buy_or_sell
  end
end

class Stonk
  include Capybara::DSL
  include Capybara::RSpecMatchers

  attr_accessor :last_known_price, :updated_price, :base_price

  def initialize(options = {})
    @last_known_price = 0
    @updated_price = 0
    @base_price = 0
    @cost_basis_delta = 0
    @position = 'out'
  end

  def get_base_price
    @base_price = find(:class_starts, 'QuoteBar---changes').all('li')[1].text.chomp.to_f
  end

  def get_updated_price
    @updated_price = find(:class_starts, 'QuoteBar---changes').all('li')[1].text.chomp.to_f
  end

  def price_changed?
    if @updated_price != @last_known_price
      return true
    else
      return false
    end
  end

  def track_deltas
    tick_delta = (@last_known_price - @updated_price).round(4)
    @cost_basis_delta = (@last_known_price - @base_price).round(4)
    if tick_delta > 0
      Log.info 'Price increase of %s' % tick_delta
      Log.info 'Total difference from cost basis is %s' % @cost_basis_delta
    else
      Log.info 'Price decrease of %s' % tick_delta
      Log.info 'Price difference from cost basis is %s' % @cost_basis_delta
    end
  end

  def set_price_targets
    # Round up cost basis delta to closest 10 cents if position is "in"
    # Round down cost basis delta to closest 10 cents if position is "out"
  end

  def buy_or_sell
    # Complete market buy or sell based on position and based on
    # price targets. We will experiment with price swings of 10 cents
    # in the hopes that we find a sustained change in price (up or down,
    # both are good for us). The thesis is that if we can ride even 30-40
    # cent swings up or down, that may be enough to turn a profit at the end
    # of the day and avoid big losses and capture big gains.
  end
end
