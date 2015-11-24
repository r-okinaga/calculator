#計算機プログラム
#構文規則
#数値：[0-9]
#演算子：+ - * / ( )

require "strscan"

def main
    while true
        print "enter a formula. type 'q' to quit.\n"
        formula = gets.chomp
        break if /q/i =~ formula
        tokens = devide_into_token(formula)
        ans = []
        parse(tokens, ans)
        p formula + "=" + ans[0][1].to_s
    end
end

def devide_into_token(formula)
    s = StringScanner.new(formula)
    token_array = Array.new

    while !s.eos?  do
        case
        when s.scan(/\*/)
            token_array << [:*, s[0]]
        when s.scan(/\//)
            token_array << [:/, s[0]]
        when s.scan(/\+/)
            token_array << [:+,s[0]]
        when s.scan(/\-/)
            token_array << [:-,s[0]]
        when s.scan(/\(/)
            token_array << [:before_p, s[0]]
        when s.scan(/\)/)
            token_array << [:after_p, s[0]]
        when s.scan(/\d+(\.\d+)?/)
            token_array << [:value,s[0]]
        else
            raise "有効でない文字列が含まれています。"
        end

    end
    token_array << [:end, :end]
end

def parse(tokens, stack)
    until tokens[0][0] == :end do
        expr(tokens, stack)
    end
end

def expr(tokens, stack)
    until tokens[0][0] == :+ || tokens[0][0] == :- || tokens[0][0] == :end do
        term(tokens, stack)
    end
    if tokens[0][0] == :+ && glance(tokens) == true
        left = stack.pop
        l = left[1].to_f
        tokens.shift
        right = tokens.shift
        r = right[1].to_f
        stack << [:value, l + r]
    elsif tokens[0][0] == :- && glance(tokens) == true
        left = stack.pop
        l = left[1].to_f
        tokens.shift
        right = tokens.shift
        r = right[1].to_f
        stack << [:value, l - r]
    elsif glance(tokens) == false
        tmp = tokens.shift
        if tokens[1][0] == :*
            left = tokens.shift
            l = left[1].to_f
            tokens.shift
            right = tokens.shift
            r = right[1].to_f
            tokens.unshift([:value, l * r])
            tokens.unshift(tmp)
        elsif tokens[1][0] == :/
            left = tokens.shift
            l = left[1].to_f
            tokens.shift
            right = tokens.shift
            r = right[1].to_f
            tokens.unshift([:value, l / r])
            tokens.unshift(tmp)
        end
    end
end

def term(tokens, stack)
    until tokens[0][0] == :* || tokens[0][0] == :/ || tokens[0][0] == :end do
        break if tokens[0][0] == :+ || tokens[0][0] == :-
        factor(tokens, stack)
    end

    expr(tokens, stack) if tokens[0][0] == :+ || tokens[0][0] == :-

    if tokens[0][0] == :*
        left = stack.pop
        l = left[1].to_f
        tokens.shift
        right = tokens.shift
        r = right[1].to_f
        stack << [:value, l * r]
    elsif tokens[0][0] == :/
        left = stack.pop
        l = left[1].to_f
        tokens.shift
        right = tokens.shift
        r = right[1].to_f
        stack << [:value, l / r]
    end

end

def factor(tokens, stack)
    if tokens[0][0] == :value
        stack << tokens.shift
    elsif tokens[0][0] == :after_p
        tokens.shift
    elsif tokens[0][0] == :before_p
        tokens.shift
        until tokens[0][0] == :after_p || tokens[0][0] == :end do
            expr(tokens, stack)
        end
    end
end

def glance(tokens)
    if 1 < tokens.length && tokens[2][0] == :* || 1 < tokens.length && tokens[2][0] == :/
        false
    else
        true
    end
end

main