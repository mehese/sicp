# Below is basically just a prototype for parsing in string inputs and translating them
# to a s-expr structure where we have the building blocks on top of which we can add
# the various operators needed for an evaluator.
#
# Here I am trying to avoid Python functions/libraries that would generally make my life 
# too easy, as I want something that can be translated to C by someone with next to no
# C experience.

from enum import Enum
from typing import List

class LispType(Enum):
    NULL = 0
    NUMBER = 1
    SYMBOL = 2
    QUOTE = 3
    FUNCTION = 4
    PAIR = 5

class LispObject:
    def __init__(
            self, lisp_type: LispType, 
            num_val=0, symbol_text="", quote_contents=None, 
            car=None, cdr=None
        ):
        self.type = lisp_type
        self.num_value = num_val
        self.text_of_quotation = quote_contents
        self.symbol_text = symbol_text
        self.car = car
        self.cdr = cdr

    def __repr__(self):
        if self.type == LispType.NULL:
            return "NULL"
        elif self.type == LispType.NUMBER:
            return str(self.num_value)
        elif self.type == LispType.SYMBOL:
            return str(self.symbol_text)
        elif self.type == LispType.QUOTE:
            return "'" + self.text_of_quotation.__repr__()
        elif self.type == LispType.FUNCTION:
            return "LispFun"
        elif self.type == LispType.PAIR:
            return f"[{self.car} {self.cdr}]"

def _get_paren_span(expr):
    if '(' not in expr[0]:
        return 1 # Car is an atom
    else:
        open_parens = 0
        num_tokens = 0
        # The number of tokens in car is the point where
        #  all the open parens are closed
        for token in expr:
            num_tokens += 1

            if token in ('(', "'("):
                open_parens += 1
            elif token == ')':
                open_parens -= 1
            if open_parens == 0:
                break
        return num_tokens


def parse(expr: List[str]) -> LispObject:
    def _is_number(token):
        try:
            float(token)
            return True
        except ValueError:
            return False

    if not expr: # Empty input
        return LispObject(LispType.NULL)
    elif expr[0] in (')', 'nil'): # End of list
        return LispObject(LispType.NULL)
    elif len(expr) == 1: # Atom case 
        atom = expr[0]
        if _is_number(atom): # Number case
            return LispObject(LispType.NUMBER, num_val=float(atom))
        elif atom[0] == "'": # Quoted atom case
            quoted_symbol = parse([ atom[1:] ])
            return LispObject(LispType.QUOTE, quote_contents=quoted_symbol)
        else: # Symbol case
            return LispObject(LispType.SYMBOL, symbol_text=atom)
    elif expr[0] == "'(": # Quoted list case
        val = LispObject(LispType.QUOTE)
        expr[0] = "("
        quote_size = _get_paren_span(expr)
        val.text_of_quotation = parse(expr[:quote_size])
        return val
    elif expr[0] == "(": # List case
        # Remove first paranthesis -- this is because lists are (car1 (car2 (car3 NIL)))
        expr = expr[1:]
        val = LispObject(LispType.PAIR)
        car_size = _get_paren_span(expr)
        val.car = parse(expr[:car_size])
        rest_of_expression = expr[car_size:]

        # Carry the paranthesis forward except in the case when we have a final ')'
        if len(rest_of_expression) > 1:
            rest_of_expression = ["("] + rest_of_expression
        val.cdr = parse(rest_of_expression)

        return val
    else:
        raise Exception("Invalid input to parse", expr)

def tidy_up(input_text:str) -> List[str]:
    """This is so we can just use strtok to iterate through elements"""
    elements = (
        input_text
        # The shorthand for NULL can mess our list processing up
        .replace("'()", "nil")
        .replace("(", "( ")
        .replace(")", " )")
        .split(" ")
    )
    return elements


def print_obj(res: LispObject):
    print(res)

def test_all():
    # Test Simple Pair
    raw_expr = '(1)'
    x = parse(tidy_up(raw_expr))
    assert x.car.num_value == 1
    print(f"{raw_expr} -> {x}")

    # Test double pair
    raw_expr = '(1 2)'
    x = parse(tidy_up(raw_expr))
    assert x.car.num_value == 1
    assert x.cdr.type == LispType.PAIR
    assert x.cdr.car.num_value == 2
    print(f"{raw_expr} -> {x}")

    # Test long list
    raw_expr = "(4 3 2 1)"
    x = parse(tidy_up(raw_expr))
    assert x.car.num_value == 4
    assert x.cdr.car.num_value == 3
    assert x.cdr.cdr.car.num_value == 2
    assert x.cdr.cdr.cdr.car.num_value == 1
    assert x.cdr.cdr.cdr.cdr.type == LispType.NULL
    print(f"{raw_expr} -> {x}")

    # Test nested
    raw_expr = "(1 (2) 3)"
    x = parse(tidy_up(raw_expr))
    assert x.cdr.car.car.num_value == 2
    assert x.cdr.cdr.car.num_value == 3, "you probably forgot to carry a parens"
    print(f"{raw_expr} -> {x}")

    # Test symbol
    raw_expr = "(a b c d)"
    x = parse(tidy_up(raw_expr))
    assert x.car.symbol_text == "a"
    assert x.cdr.car.symbol_text == "b"
    assert x.cdr.cdr.car.symbol_text == "c"
    assert x.cdr.cdr.cdr.car.symbol_text == "d"
    assert x.cdr.cdr.cdr.cdr.type == LispType.NULL
    print(f"{raw_expr} -> {x}")

    # Test quote atom
    raw_expr = "'a"
    x = parse(tidy_up(raw_expr))
    assert x.text_of_quotation.type == LispType.SYMBOL
    assert x.text_of_quotation.symbol_text == "a"
    print(f"{raw_expr} -> {x}")

    # Test NULL shorthand 
    raw_expr = "'()"
    x = parse(tidy_up(raw_expr))
    assert x.type == LispType.NULL
    print(f"{raw_expr} -> {x}")

    # Test NULL shorthand in list
    raw_expr = "(1 '() 1)"
    x = parse(tidy_up(raw_expr))
    print(x)
    assert x.type == LispType.PAIR
    assert x.car.type ==  LispType.NUMBER
    assert x.car.num_value == 1
    assert x.cdr.car.type == LispType.NULL
    assert x.cdr.cdr.car.type == LispType.NUMBER
    assert x.cdr.cdr.car.num_value == 1
    print(f"{raw_expr} -> {x}")
 
    # Test quote list
    raw_expr = "'(a 2)"
    x = parse(tidy_up(raw_expr))
    assert x.text_of_quotation.type == LispType.PAIR
    print(f"{raw_expr} -> {x}")

    # Test quoted list in list
    raw_expr = "('(a))"
    x = parse(tidy_up(raw_expr))
    assert x.car.type == LispType.QUOTE
    assert x.car.text_of_quotation.type == LispType.PAIR
    assert x.car.text_of_quotation.car.type == LispType.SYMBOL
    assert x.car.text_of_quotation.car.symbol_text == "a"
    assert x.cdr.type == LispType.NULL
    print(f"{raw_expr} -> {x}")

    print("Tests passed OK!")
 
if __name__ == "__main__":
    test_all()
    while True:
        x = input("Scheme > ")
        parsed_input = parse(tidy_up(x))
        print_obj(parsed_input)
