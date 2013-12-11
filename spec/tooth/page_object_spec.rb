require_relative '../spec_helper'

module Tooth
  describe PageObject do
    before do
      Capybara.app = TestApp
      Capybara.app_host = nil
    end

    def visit path
      Capybara.current_session.visit path
    end

    class TestPageComponent
      extend PageObject

      element :inside_div, '.second-lvl'
      element :not_existing, '#not-existing-element'
    end

    class TestPageObject
      extend PageObject

      # simple_divs
      element :some_div, 'div#some-id'
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

    describe '#shows?' do
      it 'Raise error when element is not found' do
        visit '/simple_divs'
        expect{ TestPageObject.shows? { not_existing } }.to raise_error
      end

      it 'Does nothing when element is found' do
        visit '/simple_divs'
        TestPageObject.shows? { some_div }
      end
    end

    describe '#not_shows?' do
      it 'Does nothing when element is not found' do
        visit '/simple_divs'
        TestPageObject.not_shows? { not_existing }
      end

      it 'Raise error when element is found' do
        visit '/simple_divs'
        expect{ TestPageObject.not_shows? { some_div } }.to raise_error
      end
    end

    describe '#element' do
      it 'returns Capybara::Element' do
        visit '/simple_divs'

        expect(TestPageObject.some_div).to be_an_instance_of(Capybara::Node::Element)
      end

      it 'finds element by specified selector' do
        visit '/simple_divs'

        expect(TestPageObject.some_div.text).to eq 'some'
      end

      it 'finds element by specified lambda selector' do
        visit '/simple_divs'

        expect(TestPageObject.some_div_lambda('id').text).to eq 'some'
        #puts TestPageObject.some_div_lambda('not-exist').text
        expect { TestPageObject.some_div_lambda('not-exist').text }.to raise_error(Capybara::ElementNotFound)
      end

      it 'raise error when element cannot be found on the page' do
        visit '/simple_divs'

        expect { TestPageObject.not_existing }.to raise_error(Capybara::ElementNotFound)
      end

      it 'allows chaining of capybara finders' do
        visit '/nested_divs'

        declared_element = TestPageObject.some_div
        res = declared_element.find(".second-lvl").text

        expect(res).to eq 'Second content'
      end

      it 'works inside #within scope' do
        visit '/components_divs'

        expect(TestPageObject.inside_div.text).to eq 'Correct text'
      end

      specify 'lambda selector works inside #within scope' do
        visit '/components_divs'

        expect(TestPageObject.inside_div_lambda('lvl').text).to eq 'Correct text'
      end

      specify 'capybara finders work for page objects' do
        visit '/components_divs'

        expect(TestPageObject.find('#component1-id .second-lvl').text).to eq 'Correct text'
      end
    end

    describe '#component' do
      it 'returns specified component' do
        visit '/components_divs'
        expect(TestPageObject.component1).to eq(TestPageComponent)
      end

      specify 'component can query nested Capybara::Elements' do
        visit '/components_divs'
        expect(TestPageObject.component1.inside_div).to be_an_instance_of(Capybara::Node::Element)
      end

      specify 'component queries all contents inside his declared selectors' do
        visit '/components_divs'
        expect(TestPageObject.component1.inside_div.text).to eq 'Correct text'
      end

      specify 'component correctly works with lambda locators' do
        visit '/components_divs'
        expect(TestPageObject.component1_lambda('id').inside_div.text).to eq 'Correct text'
        expect{TestPageObject.component1_lambda('missing')}.to raise_error(Capybara::ElementNotFound)
      end

      specify 'component raise error when cannot find element' do
        visit '/components_divs'
        expect { TestPageObject.component1.not_existing }.to raise_error(Capybara::ElementNotFound)
      end

      it 'works inside #within scope' do
        visit '/components2_divs'
        expect(TestPageObject.component2.inside_div.text).to eq 'Correct text'
      end
    end

    describe '#within' do
      specify 'works with nesting' do
        visit '/components2_divs'
        expect(TestPageObject.nested_in_within.text).to eq 'Correct text'
      end
    end
  end
end
