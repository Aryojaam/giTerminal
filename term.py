from blessed import Terminal
term = Terminal()
import signal
import sys
signal.signal(signal.SIGINT, lambda x, y: sys.exit(0))
# options = ["select branch", "status", "good", "bad"]
options = [
    "1", "2", "3",
    "4", "5","6",
    "7", "8", "9",
    "10","11", "12",
    "13", "14"
]

keyPressed = ""
selectedOption = 0
x, y = 0, 0
COLUMNS = 3
ITEM_WIDTH = term.width // COLUMNS

def printOptions():
    for i in range(len(options)):        
        x = ITEM_WIDTH * (i % COLUMNS)
        y = i // COLUMNS
        print(term.move_xy(x, y + 1), end='')
        if (i == selectedOption):
            print(term.reverse(options[i]), end='')
        else:
            print(options[i], end='')
    print(term.home + term.black_on_darkkhaki(term.center('Select Action')))

def handleKeyPress():
    global selectedOption
    global keyPressed
    if keyPressed == "KEY_LEFT" and selectedOption % COLUMNS != 0:
        selectedOption = (selectedOption - 1) % len(options)
    if keyPressed == "KEY_RIGHT" and selectedOption % COLUMNS != (COLUMNS - 1) and selectedOption != len(options) - 1:
        selectedOption = (selectedOption + 1) % len(options)
    if keyPressed == "KEY_UP" and selectedOption >= COLUMNS:
        selectedOption = (selectedOption - COLUMNS) % len(options)
    if keyPressed == "KEY_DOWN" and selectedOption < len(options) - COLUMNS:
        selectedOption = (selectedOption + COLUMNS) % len(options)
    if keyPressed == "KEY_ENTER":
        return options[selectedOption]

def paint():
    returnValue = handleKeyPress()
    printOptions()
    print(term.home)
    return returnValue

def selectFromOptions(options = []):
    if len(options) != 0:
        options = options
    with term.cbreak(), term.hidden_cursor():
        print(term.clear)
        global keyPressed
        while True:
            returnValue = paint()
            if returnValue is not None:
                break
            keyPressed = term.inkey().name

selectFromOptions()