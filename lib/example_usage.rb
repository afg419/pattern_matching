require_relative 'pattern_matching'

class Example

  def expect_formatted_input(input)
    pattern_match([{a: :b, c: :d}, [:e, :f]], input) do
      { @a => (@b + @d), @c => (@e * @f + @b) }
    end
  end

end

e = Example.new

p e.expect_formatted_input([{x: 1, y: 2}, [3 , 4]]) #=> {:x=>3, :y=>13}
p e.expect_formatted_input([{x: 1}, [3 , 4]]) #=> PatternMatching::NoPossibleMatchError
