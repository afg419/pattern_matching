require 'pry'

module PatternMatching
  class NoPossibleMatchError < StandardError
  end

  class IllegalMatcherError < StandardError
  end

  def pattern_match(matcher, expression)
    @var_names = []
    pm(matcher, expression)
    return_value = yield
    reset_instance_vars
    @var_names = nil
    return_value
  end

  def pm(matcher, expression)
    case
    when unmatchable(matcher, expression) then raise NoPossibleMatchError
    when matcher.is_a?(Array)             then match_arrays(matcher, expression)
    when matcher.is_a?(Hash)              then match_hashes(matcher, expression)
    when legal_matcher?(matcher)          then match_single_element(matcher, expression)
    else raise IllegalMatcherError
    end
  end

  def reset_instance_vars
    @var_names.each do |var_name|
      eval("@#{var_name} = nil")
    end
  end

  def unmatchable(matcher, expression)
    if matcher.is_a?(Enumerable)
      return true unless matcher.class == expression.class
      return true unless matcher.count == expression.count
    end
    false
  end

  def match_arrays(matcher, expression)
    matcher.each_index do |i|
      pm(matcher[i], expression[i])
    end
  end

  def match_hashes(matcher, expression)
    pm(matcher.keys, expression.keys)
    pm(matcher.values, expression.values)
  end

  def match_single_element(var_name, element)
    element = pad_string(element) if element.class == String
    element = pad_symbol(element) if element.class == Symbol
    eval("@#{var_name} = #{element}")
    eval("@var_names << '#{var_name}'") if @var_names
  end

  def legal_matcher?(matcher)
    return false unless matcher.is_a?(String) || matcher.is_a?(Symbol)
    return false unless matcher =~ /^[a-z_][a-zA-Z_0-9]*$/
    true
  end

  def pad_string(expression)
    "'" + expression + "'"
  end

  def pad_symbol(expression)
    ":" + expression.to_s
  end
end
