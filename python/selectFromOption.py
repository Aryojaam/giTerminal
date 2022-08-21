from blessed import Terminal
from utils import printNoLB
import signal, sys

term = Terminal()
signal.signal(signal.SIGINT, lambda x, y: sys.exit(0))

keyPressed = ""
selectedOption = 0
COLUMNS = 3
ITEM_WIDTH = term.width // COLUMNS

def printOptions(options, title):
    print(term.home + term.center(term.black_on_skyblue(f'  {title}  ')))
    ROWS = len(options) // COLUMNS
    for i in range(len(options)):        
        x = ITEM_WIDTH * (i % COLUMNS)
        y = i // COLUMNS
        printNoLB(term.move_xy(x, y + 1))
        if (i == selectedOption):
            printNoLB(term.reverse(options[i]))
        else:
            printNoLB(options[i])
    # navigate to the end of the options
    print(term.move_y(ROWS + 1))

def handleKeyPress(options):
    global selectedOption, keyPressed
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

def paint(options, title = ""):
    returnValue = handleKeyPress(options)
    printOptions(options, title)
    return returnValue

def selectFromOptions(options = [], title = ""):
    with term.cbreak(), term.hidden_cursor():
        print(term.clear)
        global keyPressed
        while True:
            returnValue = paint(options, title)
            if returnValue is not None:
                return returnValue
            keyPressed = term.inkey().name
