import functools
import collections

from blessed import Terminal


# python 2/3 compatibility, provide 'echo' function as an
# alias for "print without newline and flush"
try:
    # pylint: disable=invalid-name
    #         Invalid constant name "echo"
    echo = functools.partial(print, end='', flush=True)
    echo(u'')
except TypeError:
    # TypeError: 'flush' is an invalid keyword argument for this function
    import sys

    def echo(text):
        """Display ``text`` and flush output."""
        sys.stdout.write(u'{}'.format(text))
        sys.stdout.flush()



Cursor = collections.namedtuple('Cursor', ('y', 'x', 'term'))

def input_filter(keystroke):
    """
    For given keystroke, return whether it should be allowed as input.
    This somewhat requires that the interface use special application keys to perform functions, as
    alphanumeric input intended for persisting could otherwise be interpreted as a command sequence.
    """
    if keystroke.is_sequence:
        # Namely, deny multi-byte sequences (such as '\x1b[A'),
        return False
    if ord(keystroke) < ord(u' '):
        # or control characters (such as ^L),
        return False
    return True

def echo_yx(cursor, text):
    """Move to ``cursor`` and display ``text``."""
    echo(cursor.term.move_yx(cursor.y, cursor.x) + text)


def right_of(csr, offset):
    return Cursor(y=csr.y,
                    x=min(csr.term.width - 1, csr.x + offset),
                    term=csr.term)

def left_of(csr, offset):
    return Cursor(y=csr.y,
                x=max(0, csr.x - offset),
                term=csr.term)

def below(csr, offset):
    return Cursor(y=min(csr.term.height - 1, csr.y + offset),
                    x=csr.x,
                    term=csr.term)

def home(csr):
    return Cursor(y=csr.y,
                    x=0,
                    term=csr.term)

def lookup_move(inp_code, csr):
    return {
        # arrows, including angled directionals
        # csr.term.KEY_END: below(left_of(csr, 1), 1),
        # csr.term.KEY_KP_1: below(left_of(csr, 1), 1),

        # csr.term.KEY_DOWN: below(csr, 1),
        # csr.term.KEY_KP_2: below(csr, 1),

        # csr.term.KEY_PGDOWN: below(right_of(csr, 1), 1),
        # csr.term.KEY_LR: below(right_of(csr, 1), 1),
        # csr.term.KEY_KP_3: below(right_of(csr, 1), 1),

        csr.term.KEY_LEFT: left_of(csr, 1),
        # csr.term.KEY_KP_4: left_of(csr, 1),

        # csr.term.KEY_CENTER: center(csr),
        # csr.term.KEY_KP_5: center(csr),

        csr.term.KEY_RIGHT: right_of(csr, 1),
        # csr.term.KEY_KP_6: right_of(csr, 1),

        # csr.term.KEY_HOME: above(left_of(csr, 1), 1),
        # csr.term.KEY_KP_7: above(left_of(csr, 1), 1),

        # csr.term.KEY_UP: above(csr, 1),
        # csr.term.KEY_KP_8: above(csr, 1),

        # csr.term.KEY_PGUP: above(right_of(csr, 1), 1),
        # csr.term.KEY_KP_9: above(right_of(csr, 1), 1),

        # shift + arrows
        # csr.term.KEY_SLEFT: left_of(csr, 10),
        # csr.term.KEY_SRIGHT: right_of(csr, 10),
        # csr.term.KEY_SDOWN: below(csr, 10),
        # csr.term.KEY_SUP: above(csr, 10),

        # carriage return
        # csr.term.KEY_ENTER: home(below(csr, 1)),
    }.get(inp_code, csr)

def read(term):
    x, y = term.get_location()
    csr = Cursor(x, y, term)
    screen = {}
    text = u''
    with term.hidden_cursor(), term.raw(), term.location(), term.keypad():
        inp = None
        while True:
            echo_yx(csr, term.reverse(screen.get((csr.y, csr.x), u' ')))
            inp = term.inkey()

            if inp == chr(3):
                # ^c exits
                break

            if inp.code == term.KEY_ENTER:
                # ^c exits
                break

            if inp.code in (term.KEY_BACKSPACE, term.KEY_DELETE):
                text = text[:-1]
                print(u'\b \b')

            else:
                n_csr = lookup_move(inp.code, csr)

            if n_csr != csr:
                # erase old cursor,
                echo_yx(csr, screen.get((csr.y, csr.x), text[csr.y]))
                csr = n_csr

            elif input_filter(inp):
                echo_yx(csr, inp)
                text += inp.__str__()
                n_csr = right_of(csr, 1)
                if n_csr == csr:
                    # wrap around margin
                    n_csr = home(below(csr, 1))
                csr = n_csr
    return text 

print(read(Terminal()))