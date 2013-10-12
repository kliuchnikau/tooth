module PageObject
  def within scope_locator, &block
    within_scope_klass = Class.new
    within_scope_klass.extend PageObject
    within_scope_klass.instance_variable_set :@page_element, page_element
    within_scope_klass.element_with_finders = -> { element_with_finders.find(scope_locator) }
    within_scope_klass.class_eval &block
  end

  def link name, locator
    page_element[name] = ->(*args){ element_with_finders.find_link(locator_string(locator, args)) }
  end

  def field name, locator
    page_element[name] = ->(*args){ element_with_finders.find_field(locator_string(locator, args)) }
  end

  def button name, locator
    page_element[name] = ->(*args){ element_with_finders.find_button(locator_string(locator, args)) }
  end

  def element name, locator, options = {}
    page_element[name] = ->(*args){
      element_with_finders.find(locator_string(locator, args), options)
    }
  end

  def component name, component_class, locator, options = {}
    page_element[name] = ->(*args){
      component_element = find(locator_string(locator, args), options)
      component_class.tap do |cmp|
        cmp.element_with_finders = component_element
      end
    }
  end

  # convenience methods
  def shows? &block
    instance_eval &block
  end
  alias :scenario :shows?

  def not_shows? &block
    instance_eval &block
  rescue Capybara::ElementNotFound
  else
    raise 'Element is shown'
  end
  protected
  # currently this is not thread safe solution, because we do not create instance of component, but reuse component class.
  # here we trade usability of the framework for the thread safeness. Need to think about this issue and better solutions.
  attr_writer :element_with_finders

  private
  def locator_string(locator, args)
    locator.kind_of?(Proc) ? locator.call(*args) : locator
  end

  def page_element; @page_element ||= {} end

  def element_with_finders
    if @element_with_finders
      @element_with_finders.kind_of?(Proc) ? @element_with_finders.call : @element_with_finders
    else
      Capybara.current_session
    end
  end

  def method_missing(meth, *args, &block)
    if( element_finder = page_element[meth.to_sym])
      element_finder.call(*args)
    else
      element_with_finders.send(meth, *args, &block)
    end
  end
end
