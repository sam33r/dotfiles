import i3ipc

FOCUSED_WINDOW_RATIO = 0.621

# Create the Connection object that can be used to send commands and subscribe
# to events.
i3 = i3ipc.Connection()

w = i3.get_workspaces()
WIDTH = w[0].rect.width
print WIDTH


# Grow focused window.
def on_window_focus(i3, e):
  window_id = e.container.props.id
  width = e.container.window_rect.width

  current_ratio = float(width) / float(WIDTH)
  increment = int((FOCUSED_WINDOW_RATIO - current_ratio) * 100)

  # There's a weird bug where resize by percentage points isn't working.
  # The following code does a best-effort attempt to get as close to desired
  # ratio as possible.
  iterations = increment / 10

  for i in range(abs(iterations)):
    if increment > 0:
      i3.command('[con_id=%s] resize grow width' % window_id)
    else:
      i3.command('[con_id=%s] resize shrink width ' % window_id)

  print 'width %d WIDTH %d current ratio %f increment %d' % (
      width, WIDTH, current_ratio, increment)

  focused = i3.get_tree().find_focused()
  print('Focused window %s is on workspace %s' %
        (focused.name, focused.workspace().name))
  print 'new width: %d' % focused.window_rect.width


# Remove fullscreen mode when a new window is created.
def on_new_window(i3, e):
  for container in i3.get_tree().find_fullscreen():
    container.command('fullscreen')


# Subscribe to events
i3.on('window::focus', on_window_focus)
i3.on('window::new', on_new_window)

# Start the main loop and wait for events to come in.
i3.main()
