# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# The generated `.rspec` file contains `--require spec_helper` which will cause
# this file to always be loaded, without a need to explicitly require it in any
# files.
#
# Given that it is always loaded, you are encouraged to keep this file as
# light-weight as possible. Requiring heavyweight dependencies from this file
# will add to the boot time of your test suite on EVERY test run, even for an
# individual file that may not need all of that loaded. Instead, consider making
# a separate helper file that requires the additional dependencies and performs
# the additional setup, and require it from the spec files that actually need
# it.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

require 'webdrivers'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'logger'
require 'helper_functions'
require 'bigdecimal'
require 'bigdecimal/util'

RSpec.configure do |config|
  config.order = 'default' # Run specs in default order
  config.expect_with :rspec do |c| # Allow should syntax, which is now deprecated in rspec3
    c.syntax = [:should, :expect]
  end
  config.after(:each) do |example|
    if example.exception
      page.save_page
      page.save_screenshot
    end
  end
end

Capybara.add_selector(:class_starts) do
  css {|locator| "[class^=\"#{locator}\"]"}
end

Capybara.configure do |config|
  config.match = :prefer_exact
  config.save_path = 'failure_assets'
  config.default_max_wait_time = 5 # Waiting for an element will timeout at 5 seconds
  config.default_normalize_ws = true # Allow relaxed matching of lengthier blocks of text
  config.default_driver = :selenium_chrome
end
