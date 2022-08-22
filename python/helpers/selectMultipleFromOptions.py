from blessed import Terminal
from helpers.utils import printNoLB
import signal, sys

term = Terminal()
signal.signal(signal.SIGINT, lambda x, y: sys.exit(0))

keyPressed = ""
selectedOption = 0
COLUMNS = 3
ITEM_WIDTH = term.width // COLUMNS
markedOptions = []

def printOptions(options, title):
    global markedOptions
    print(term.home + term.center(term.black_on_skyblue(f'  {title}  ')))
    ROWS = len(options) // COLUMNS
    for i in range(len(options)):
        x = ITEM_WIDTH * (i % COLUMNS)
        y = i // COLUMNS
        printNoLB(term.move_xy(x, y + 1))
        item = options[i]
        if (item in markedOptions):
            item = "☒ " + item
        else:
            item = "□ " + item
        if (i == selectedOption):
            printNoLB(" " + term.reverse(item) + " ")
        else: # the spaces is for evening out the selection
            printNoLB(" " + item + "  ")
    # navigate to the end of the options
    print(term.move_y(ROWS + 1))

def handleKeyPress(options):
    global selectedOption, markedOptions, keyPressed
    if keyPressed == "KEY_LEFT" and selectedOption % COLUMNS != 0:
        selectedOption = (selectedOption - 1) % len(options)
    if keyPressed == "KEY_RIGHT" and selectedOption % COLUMNS != (COLUMNS - 1) and selectedOption != len(options) - 1:
        selectedOption = (selectedOption + 1) % len(options)
    if keyPressed == "KEY_UP" and selectedOption >= COLUMNS:
        selectedOption = (selectedOption - COLUMNS) % len(options)
    if keyPressed == "KEY_DOWN" and selectedOption < len(options) - COLUMNS:
        selectedOption = (selectedOption + COLUMNS) % len(options)
    if keyPressed == " ":
        if (options[selectedOption] in markedOptions):
            markedOptions.remove(options[selectedOption])
        else:
            markedOptions.append(options[selectedOption])
    if keyPressed == "KEY_ENTER":
        return markedOptions

def paint(options, title = ""):
    returnValue = handleKeyPress(options)
    printOptions(options, title)
    return returnValue

def selectMultipleFromOptions(options = [], title = ""):
    with term.cbreak(), term.hidden_cursor():
        print(term.clear)
        global keyPressed, selectedOption, markedOptions
        # these options have to be reset after each execution
        selectedOption = 0
        keyPressed = ""
        markedOptions = []
        while True:
            returnValue = paint(options, title)
            if returnValue is not None:
                return returnValue
            val = term.inkey()
            if val.is_sequence:
                keyPressed = val.name
            elif val:
                keyPressed = val
