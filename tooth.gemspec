Gem::Specification.new do |s|
  s.name        = 'tooth'
  s.version     = '0.2.0'
  s.date        = '2013-12-11'
  s.description = 'Simple page objects for Capybara. All tooth-generated methods return Capybara Elements so that you can use these familiar objects for your needs.'
  s.summary     = 'Simple page objects for Capybara'
  s.authors     = ['Aliaksei Kliuchnikau']
  s.email       = 'aliaksei.kliuchnikau@gmail.com'
  s.files       = ["lib/tooth.rb"]
  s.homepage    = 'https://github.com/kliuchnikau/tooth'

  s.add_dependency('capybara', '>= 2.0.0')
  s.add_development_dependency('rspec')
  s.add_development_dependency('sinatra')
end
