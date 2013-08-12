Gem::Specification.new do |s|
  s.name        = 'tooth'
  s.version     = '0.0.1'
  s.date        = '2013-08-12'
  s.description = "Simple page objects for Capybara"
  s.summary     = "Simple page objects for Capybara"
  s.authors     = ["Aliaksei Kliuchnikau"]
  s.files       = ["lib/tooth.rb"]
  s.homepage    = 'https://github.com/kliuchnikau/tooth'

  s.add_dependency('capybara', '>= 2.0.0')
  s.add_development_dependency('rspec')
  s.add_development_dependency('sinatra')
end
