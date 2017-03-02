function notify
  set st $status
  if math "$st > 0"
    notify-send --urgency=critical --expire-time=20000 $argv "\nCommand exit status: $st"
  else
	  notify-send --expire-time=20000 $argv "\nCommand exit status: $st"
  end
end
