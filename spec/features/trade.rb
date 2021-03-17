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
    within_window @win do
      base_price = get_price
      last_price = base_price
      while 1
        new_price = get_price
        if last_price != new_price
          diff = (last_price - new_price).round(4)
          diff2 = (last_price - base_price).round(4)
          if diff > 0
            Log.info 'Price increase of %s' % diff
            Log.info 'Price difference from cost basis is %s' % diff2
          else
            Log.info 'Price decrease of %s' % diff
            Log.info'Price difference from cost basis is %s' % diff2
          end
        end
        last_price = new_price
        buy_or_sell
      end
    end
  end

end

def get_price
  find(:class_starts, 'QuoteBar---changes').all('li')[1].text.chomp.to_f
end

def buy_or_sell

end
