#計算機プログラム
#
#

require "strscan"

def main
    print "enter a formula\n"
    formula = gets.chomp
    token_array = devide_into_token(formula)
    reverse_polish_array = to_reverse_polish(token_array)
    answer = calc(reverse_polish_array)
    p formula + "=" + answer.to_s
end

def devide_into_token(formula)

    s = StringScanner.new(formula)
    token_array = Array.new

    while !s.eos?  do
        token_array << s.scan(/\d+|\*|\/|\+|\-|\(|\)/)
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
            stack.push(token.to_i)
        end
    }
    answer = stack[0]
end
main
j