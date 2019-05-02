# typed: true
class Example
    sig {params(is_add: T::Boolean, a: Integer, b: Integer).returns(Integer)}
    def self.calulate(is_add, a, b)
        if is_add
            a + b
        else
            a - b
        end
    end
end
