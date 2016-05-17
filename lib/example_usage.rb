require_relative 'pattern_matching'

class Example
  include PatternMatching

  def expect_formatted_input(input) #use pattern_match to both check for formatted input, and also extract that input into instance vars
    pattern_match( [ {a: :b, c: :d}, [:e, :f] ], input ) do
      { @a => (@b + @d), @c => (@e * @f + @b) }
    end #though you must use instance variables within the block, these vars are reset afterwards. Watch out for naming collisions!
  end

  def instance_variables_have_been_reset
    @a
  end

end

e = Example.new

p e.expect_formatted_input( [ {x: 1, y: 2}, [3, 4] ] ) #=> { :x=>3, :y=>13 }
p e.instance_variables_have_been_reset #=> nil
p e.expect_formatted_input( [ {x: 1}, [3, 4] ] ) #=> PatternMatching::NoPossibleMatchError
