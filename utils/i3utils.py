import i3ipc

# Mapping of (Number of windows in the workspace) -> (Space the focused window
# should occupy).
DESIRED_RATIOS = {
    2: 0.621,
    3: 0.50,
    4: 0.40,
}

# Map of Workspace Name -> Associated Application.
WORKSPACE_APPS = {
    '10: Agenda': 'emacsclient -c -e "(sa/orgmode)"',
    '9: Comms': 'google-chrome gmail.com',
}

# Create the Connection object that can be used to send commands and subscribe
# to events.
i3 = i3ipc.Connection()

w = i3.get_workspaces()
WIDTH = w[0].rect.width
print WIDTH


# Grow focused window.
def on_window_focus(i3, e):
  focused = i3.get_tree().find_focused()
  workspace = focused.workspace()
  # TODO: The right number to look at is the immediate children of workspace,
  # not the total number of leaves. Also need to check if splitting is
  # horizontal.
  leaves = len(workspace.leaves())
  print leaves
  if leaves < 2 or leaves > 4:
    print 'ignoring focus because leaves count is %d' % leaves
    return

  desired_ratio = DESIRED_RATIOS[leaves]

  window_id = e.container.props.id
  width = e.container.window_rect.width

  current_ratio = float(width) / float(WIDTH)
  increment = int((desired_ratio - current_ratio) * 100)

  # There's a weird bug where resize by percentage points isn't working.
  # The following code does a best-effort attempt to get as close to desired
  # ratio as possible.
  iterations = increment / 10

  for i in range(abs(iterations)):
    if increment > 0:
      i3.command('[con_id=%s] resize grow width' % window_id)
    else:
      i3.command('[con_id=%s] resize shrink width ' % window_id)

  print 'resized, iterations: %d' % iterations


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
i3.on('window::focus', on_window_focus)
i3.on('window::new', on_new_window)
i3.on('workspace::focus', on_workspace)

# Start the main loop and wait for events to come in.
i3.main()
