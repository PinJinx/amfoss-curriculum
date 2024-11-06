## Terminal Text Editor

Here is my take on a very simple terminal text editor, in C. It creates, reads, and edits text with a little polish in the form of undo/redo and keyword highlighting. Here's a walkthrough of how I constructed this beast.

### Main Components

The whole thing starts with a user prompt: either create a new file, or read an existing one. Depending on the choice of the user, the main editing function is invoked in either new or read mode. Let's first go through each section below.

---

### Setting up and Navigating the Editor

**1. Terminal Modes (set_raw_mode & reset_terminal_mode):
Elimination of default terminal like line buffering and echoing characters were the first things to do. A call `set_raw_mode()` turns off canonical mode as well as echo so I receive input character by character without waiting for "Enter.". `reset_terminal_mode()` restores these settings so I am not ending the program with the terminal in disarray.

**2. ClearScreen: Screen clearing is next.
It simply outputs an ANSI escape code to blank the screen. Extremely useful when you need to flush out the display at any refresh.
When I make a new file, it automatically opens a temp file allowing the user to start writing immediately. If reading an existing file, it loads the specified file text into a temp one, so changes saved there first.

**2. Saving Files (ReadAndSave & CreateAndSave):
It saves based on its whether it is a new or opened file. Saves the new file under an existing name to be given to the user; for an open file, it overwrites the original file. Afterwards, it erases them both regardless.

---

Undo and redo are saved as separate files. The program keeps a pointer (`c_file_pointer`) to the last saved state, wrapping around to 0 when it reaches 20 to avoid creating too many files. Each time the text changes significantly, it causes an undo save. If you hit the undo or redo shortcuts, it swaps in text from the latest cached file. The program cleans up these cache files when you exit.

---

Editing Mode (StartWriting)

Most of the dialogue occurs here. I can read all keystrokes:

*   **CTRL+L (Redo)** and **CTRL+K (Undo):** Load from cache.
*   **CTRL+X (Exit):** It asks the user if they want to save any changes made before exiting.
*   **Backspace:** Erases the last character in both the file and memory.
*   **Search Term:** Highlights key words in text.

To keep track of everything I type, I append each character to the `text` string and write to `temp.txt`.

---

### Highlight Keywords (SplitWrds)

This one throws in some syntax-like color highlighting. I break down the input text into words and symbols and check if they match any of the predefined types (like `int`, `float`, loops, etc.). Each category of them has a color for it, so they shine when shown. Search words get a green background color, and keywords are colored as per their type, data type being blue, as an example.

---

### Showing the Text Editor

The App Bar is located on top with the name of the application and shortcuts, refreshing upon each start of text editing or viewing.

This has taught me much about raw terminal mode interaction with text, direct manipulation of files, and optimization for code readability. I have left it pretty bare-bones so far, but there's definitely room to add more - like copy-paste, better memory management, or smoother refresh of the display.
