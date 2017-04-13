function keepdoing
	while true
    set out (eval $argv; set st $status)
    echo $out
    notify-send "Output:\n$out \n\nStatus: $st"
    sleep 60
  end
end
