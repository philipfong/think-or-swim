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
        # Log.info 'New price is now %s' % new_price
        # diff = last_price - new_price
        # if diff > 0
        #   Log.info 'Up %s since last check' % diff
        # elsif diff < 0
        #   Log.info 'Down %s since last check' % diff
        # else
        #   Log.info 'No price change since last check'
        # end
        # base_difference = base_price - new_price
        # Log.info 'Difference from cost basis is %s' % base_difference
        if last_price != new_price
          Log.info 'Last price was %s' % last_price
        end
        last_price = new_price
      end
      sleep 0.250
    end
  end

end

def get_price
  find(:class_starts, 'QuoteBar---changes').all('li')[1].text
end
