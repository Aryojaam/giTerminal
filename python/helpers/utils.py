import subprocess

def printNoLB(s):
    print(s, end='')

def runCommand(command):
    try:
        splitted = command.split(' ')
        output = subprocess.check_output(splitted).decode()
        return str(output).rstrip('\n')
    except:
        return

def readline(term, width=2048):
    """A rudimentary readline implementation."""
    text = u''
    while True:
        inp = term.inkey()
        if inp.code == term.KEY_ENTER:
            break
        elif inp.code == term.KEY_ESCAPE or inp == chr(3):
            text = None
            break
        elif not inp.is_sequence and len(text) < width:
            text += inp
        elif inp.code in (term.KEY_BACKSPACE, term.KEY_DELETE):
            text = text[:-1]
            # https://utcc.utoronto.ca/~cks/space/blog/unix/HowUnixBackspaces
            #
            # "When you hit backspace, the kernel tty line discipline rubs out
            # your previous character by printing (in the simple case)
            # Ctrl-H, a space, and then another Ctrl-H."
            print(u'\b \b')
    return text
