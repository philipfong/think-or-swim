require 'spec_helper'

feature "Trade on thinkorswim platform" do

  scenario "Buy and sell SPY" do
    visit 'https://invest.ameritrade.com/grid/p/login'
    page.should have_text 'Secure Log-in'
  end

end