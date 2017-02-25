import i3ipc
from threading import Timer

# Mapping of (Number of windows in the workspace) -> (Window resize settings).
RESIZE_SETTINGS = {
    2: {
        'desired_ratio': 0.621,
        'acceptable_ratio': 0.55,
    },
    3: {
        'desired_ratio': 0.50,
        'acceptable_ratio': 0.4,
    },
    4: {
        'desired_ratio': 0.40,
        'acceptable_ratio': 0.35,
    },
    5: {
        'desired_ratio': 0.35,
        'acceptable_ratio': 0.30,
    },
    # Do not resize windows for ultrawide displays.
    'max_screen_width': 3000,
}

# Map of window title to its preset width. These windows still get affected by
# resizing of other windows.
PRESET_WIDTHS = {
    'Speedbar 1.0': 500,
}

# Map of Workspace Name -> Associated Application.
WORKSPACE_APPS = {
    '0 Agenda':
        'emacsclient -c -e "(sa/orgmode)"',
    '8 TP':
        'google-chrome --app-id=bikioccmkafdpakkkcpdbppfkghcmihk',
    '9 Comms':
        'google-chrome gmail.com hangouts.google.com calendar.google.com',
}

# Create the Connection object that can be used to send commands and subscribe
# to events.
i3 = i3ipc.Connection()

# TODO: This assumes all workspaces are the same width and that the width
# does not change.
w = i3.get_workspaces()
WIDTH = w[0].rect.width
print WIDTH

# Timer to wait before resizing window.
_RESIZE_TIMER = None


def resize(i3, window_id, increment):
  # There's a weird bug where resize by percentage points isn't working.
  # The following code does a best-effort attempt to get as close to desired
  # ratio as possible.
  iterations = increment / 10

  for i in range(abs(iterations)):
    if increment > 0:
      i3.command('[con_id=%s] resize grow width' % window_id)
    #else:
    # i3.command('[con_id=%s] resize shrink width ' % window_id)

  print 'resized, iterations: %d' % iterations


def set_resize_timer(i3, increment, window_id):
  global _RESIZE_TIMER

  _RESIZE_TIMER = Timer(0.3, resize, args=[i3, window_id, increment])
  _RESIZE_TIMER.start()


# Grow focused window.
def on_window_focus(i3, e):
  global _RESIZE_TIMER
  if _RESIZE_TIMER:
    _RESIZE_TIMER.cancel()

  focused = i3.get_tree().find_focused()
  workspace = focused.workspace()
  # TODO: The right number to look at is the immediate children of workspace,
  # not the total number of leaves. Also need to check if splitting is
  # horizontal.
  leaves = len(workspace.leaves())
  print leaves
  if leaves not in RESIZE_SETTINGS:
    print 'ignoring focus because leaves count is %d' % leaves
    return

  desired_ratio = RESIZE_SETTINGS[leaves]['desired_ratio']
  acceptable_ratio = RESIZE_SETTINGS[leaves]['acceptable_ratio']

  if focused.name in PRESET_WIDTHS:
    print 'found a preset window %s' % focused.name
    acceptable_ratio = (PRESET_WIDTHS[focused.name] * 1.0 / WIDTH)
    desired_ratio = (PRESET_WIDTHS[focused.name] * 1.0 / WIDTH)

  window_id = e.container.props.id
  width = e.container.window_rect.width

  current_ratio = float(width) / float(WIDTH)
  increment = int((desired_ratio - current_ratio) * 100)

  if increment > 0 and current_ratio > acceptable_ratio:
    print 'Window is acceptably wide already. %d %d' % (current_ratio,
                                                        acceptable_ratio)
    return

  set_resize_timer(i3, increment, window_id)


# Remove fullscreen mode when a new window is created.
def on_new_window(i3, e):
  for container in i3.get_tree().find_fullscreen():
    container.command('fullscreen')


# Run associated app when a workspace is initialized.
def on_workspace(i3, e):
  if e.current.props.name in WORKSPACE_APPS and not len(e.current.leaves()):
    print 'Running %s' % WORKSPACE_APPS[e.current.props.name]
    i3.command('exec {}'.format(WORKSPACE_APPS[e.current.props.name]))


# Subscribe to events
if WIDTH < RESIZE_SETTINGS['max_screen_width']:
  i3.on('window::focus', on_window_focus)
i3.on('window::new', on_new_window)
i3.on('workspace::focus', on_workspace)

# Start the main loop and wait for events to come in.
i3.main()
