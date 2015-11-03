#計算機プログラム
#構文規則
#数値：[0-9]
#演算子：+ - * / ( )

require "strscan"
require 'test/unit'

def main
    print "enter a formula\n"
    formula = "(-21.321+2)+(5/2)"
    token_array = devide_into_token(formula)
    p token_array
    reverse_polish_array = to_reverse_polish(token_array)
    answer = calc(reverse_polish_array)
    p formula + "=" + answer.to_s
end

def devide_into_token(formula)

    s = StringScanner.new(formula)
    token_array = Array.new
    unary_ope_may = true
    unary_ope = ""

    while !s.eos?  do
        case
        when s.scan(/\*|\/|\+|\)/)
            unary_ope_may = false
            token_array << s[0]
        when s.scan(/\(/)
            unary_ope_may = true
            token_array << s[0]
        when s.scan(/\-/)
                if unary_ope_may then
                    unary_ope = "-"
                else
                    token_array << s[0]
                end
        when s.scan(/\d+(\.\d+)?/)
            token_array << unary_ope + s[0]
            unary_ope = ""
            unary_ope_may = false
        end

    end

    token_array

end

def to_reverse_polish(token_array)

    reverse_polish_array = Array.new
    stack = Array.new
    tmp = ""

    token_array.each { |token|

        if token == ")" then
            while stack.include?("(") do
                tmp = stack.pop
                reverse_polish_array << tmp
            end
            reverse_polish_array.pop
        elsif token == "(" or token == "*" or token == "/" then
            stack << token
        elsif token == "+" or token == "-" then
            while stack.include?("*") or stack.include?("/") do
                tmp = stack.pop
                reverse_polish_array << tmp
            end
            stack << token
        else
            reverse_polish_array << token
        end

    }
    while stack.any? do
        tmp = stack.pop
        reverse_polish_array << tmp
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