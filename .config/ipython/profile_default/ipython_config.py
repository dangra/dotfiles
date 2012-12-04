# Configuration file for ipython.

c = get_config()
c.TerminalIPythonApp.display_banner = False
c.TerminalIPythonApp.ignore_old_config = True
c.TerminalIPythonApp.classic = True
c.TerminalInteractiveShell.color_info = True
c.TerminalInteractiveShell.history_length = 10000

# c.TerminalInteractiveShell.confirm_exit = False
# c.TerminalInteractiveShell.autocall = 1
# Save multi-line entries as one entry in readline history
# c.TerminalInteractiveShell.multiline_history = True

c.TerminalInteractiveShell.separate_in = ''
c.PromptManager.color_scheme = 'Linux'
c.PromptManager.out_template = ''
c.PromptManager.in_template = '>>> '
c.PromptManager.in2_template = '... '
c.PromptManager.justify = False
