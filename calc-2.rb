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
  stack = Array.new
  reverse_polish_array = Array.new
  reverse_polish_array = to_reverse_polish(token_array, stack, reverse_polish_array)
  answer = calc(reverse_polish_array)
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

def to_reverse_polish(token_array, stack, reverse_polish_array)

  while 0 < token_array.size do
    token = token_array.shift
    if token == "("
      to_reverse_polish(token_array, stack, reverse_polish_array)
    elsif token == ")"
      while stack.any? do
        reverse_polish_array << stack.pop
      end
      p calc(reverse_polish_array)
      p reverse_polish_array
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