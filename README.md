tooth
=====

Simple page objects for [Capybara](https://github.com/jnicklas/capybara)

=====

You can create page objects and page components using simple DSL.
These page objects will incapsulate all selectors and remove duplication
from you tests:

    class NavigationComponent
      extend PageObject # inject page object 'role' for component

      element :logo, '.logo'
    end

    class HomePage
      extend PageObject

      # simple_divs
      element :headline, 'div#some-id'
      element :some_div_lambda, ->(id){ "div#some-#{id}" }
      element :not_existing, '#not-existing-element'

      # components_divs
      within 'div#component1-id' do
        element :inside_div, '.second-lvl'
        element :inside_div_lambda, ->(lvl){".second-#{lvl}"}
      end

      # components_divs
      component :component1, TestPageComponent, 'div#component1-id'
      component :component1_lambda, TestPageComponent, ->(id){ "div#component1-#{id}" }

      # components2_divs
      within '#scope-two' do
        component :component2, TestPageComponent, 'div#component1-id'
      end

      # within nesting
      within '#scope-two' do
        within '#component1-id' do
          element :nested_in_within, '.second-lvl'
        end
      end
    end

Then inside tests you can use these objects (methods return Capybara
elements):

    expect(HomePage.headline.text).to eq 'Headline text'
