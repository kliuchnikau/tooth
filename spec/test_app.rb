require 'sinatra/base'

class TestApp < Sinatra::Base
  class TestAppError < StandardError; end

  set :root, File.dirname(__FILE__)
  set :static, true
  set :raise_errors, true
  set :show_exceptions, false

  get '/simple_link' do
    'Hello world! <a href="with_html">Link</a>'
  end

  get '/simple_divs' do
    <<SIMPLE_DIVS
    <div id="one-id">one</div>
    <div id="some-id">some</div>
    <div id="other-id">other</div>
SIMPLE_DIVS
  end

  get '/nested_divs' do
    <<NESTED_DIVS
    <div id='some-id'>
      First content
      <div class='second-lvl'>
        Second content
      </div>
    </div>
NESTED_DIVS
  end

  get '/components_divs' do
    <<COMPONENTS_DIVS
    <div class='second-lvl'>No1</div>
    <div id='component1-id'>
      Component text
      <div class='second-lvl'>
        Correct text
      </div>
    </div>
    <div class='second-lvl'>No2</div>
COMPONENTS_DIVS
  end

  get '/components2_divs' do
    <<COMPONENTS2_DIVS
    <div id="scope-one">
      <div id='component1-id'>
        <div class='second-lvl'>
          Incorrect text
        </div>
      </div>
    </div>
    <div id="scope-two">
      <div id='component1-id'>
        <div class='second-lvl'>
          Correct text
        </div>
      </div>
    </div>
COMPONENTS2_DIVS
  end
end
