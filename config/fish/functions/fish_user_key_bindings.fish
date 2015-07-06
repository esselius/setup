function fish_user_key_bindings
	
  function __commandline_clear_prompt
    set -ge __prompt_context_current
    clear
    set_color normal
      fish_prompt
    commandline -f repaint
  end

  bind \cl '__commandline_clear_prompt'
end
