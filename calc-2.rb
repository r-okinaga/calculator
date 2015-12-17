#計算機プログラム
#構文規則
#数値：[0-9]
#演算子：+ - * / ( )
#正負の実数が計算可能

require "strscan"
require 'test/unit'

def main
  print "enter a formula\n"
  formula = gets.chomp
  token_array = devide_into_token(formula)
#  reverse_polish_array = to_reverse_polish(token_array)
#  reverse_polish_array = Parser.parse2(token_array)
#  answer = calc(reverse_polish_array)
  answer = Parser.parse2(token_array).to_i
  p formula + "=" + answer.to_s
end

def devide_into_token(formula)

  s = StringScanner.new(formula)
  token_array = Array.new

  while !s.eos?  do
    case
      when s.scan(/\+|\-|\*|\/|\(|\)/)
        token_array << s[0]
      when s.scan(/\d+(\.\d+)?/)
        token_array << s[0]
    end

  end

  token_array

end

class String
  def numeric?
    self =~ /^[0-9]+$/
  end
end



class Parser
  class BinOp
    def initialize(lhs, opr, rhs)
      @lhs = lhs
      @opr = opr
      @rhs = rhs
    end

    def to_i
      l = @lhs.to_i
      r = @rhs.to_i

      case @opr
        when '+'
          l + r

        when '-'
          l - r

        when '*'
          l * r

        when '/'
          l / r

        else
          raise
      end
    end

  end

  def self.parse2(token_array)
    p = Parser.new
    p.parse(token_array)
  end

  def parse(token_array)
    @token_array = token_array

    expression
  end

  def expression
    v = term

    while %w(+ -).include? token
      v = BinOp.new v, next_token, term
    end

    v
  end

  def term
    v = factor

    while ['*', '/'].include? token
      v = BinOp.new v, next_token, factor
    end

    v
  end

  def factor
    case
      when token.numeric?
        next_token

      when token == '('
        next_token
        v = expression
        assert_and_next ')'
        v

      else
        raise

    end
  end

  private

  def write(val)
    @values << val
  end

  def token
    @token_array.first
  end

  def next_token
    @token_array.shift
  end

  def assert_and_next(s)
    raise unless token == s
    next_token
  end
end

def to_reverse_polish(token_array)
  stack = Array.new
  reverse_polish_array = Array.new
  while 0 < token_array.size do
    token = token_array.shift
    if token == "("
      factor = to_reverse_polish(token_array) #kou to shite atukau
      while factor.any? do
        reverse_polish_array << factor.shift
      end
    elsif token == ")"
      while stack.any? do
        reverse_polish_array << stack.pop
      end
      return reverse_polish_array
    elsif token == "*" or token == "/" then
      while 0 < stack.size && stack.last =~ /\*|\// do
        reverse_polish_array << stack.pop
      end
      stack << token
    elsif token == "+" or token == "-" then
      while 0 < stack.size && stack.last =~ /\+|\-|\*|\// do
        reverse_polish_array << stack.pop
      end
      stack << token
    else
      reverse_polish_array << token
    end
  end

  while stack.any? do
    reverse_polish_array << stack.pop
  end
  reverse_polish_array
end

def calc(reverse_polish_array)
  stack = Array.new
  reverse_polish_array.each { |token|
    case token

      when "+" then
        r = stack.pop
        l = stack.pop
        stack.push(l + r)
      when "-" then
        r = stack.pop
        l = stack.pop
        stack.push(l - r)
      when "*" then
        r = stack.pop
        l = stack.pop
        stack.push(l * r)
      when "/" then
        r = stack.pop
        l = stack.pop
        stack.push(l / r)
      else
        stack.push(token.to_f)
    end
  }
  answer = stack[0]
end
main