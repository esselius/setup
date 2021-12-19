function fish_user_key_bindings

  bind \n '__commandline_execute'
  bind \cl '__commandline_clear_prompt'
	
  function __commandline_clear_prompt
    set -ge __prompt_context_current
    clear
    set_color normal
      fish_prompt
    commandline -f repaint
  end

  function __commandline_execute
    set value (commandline)
    if test -n "$value"
      commandline -f execute
    else
      echo
    end
  end

end
