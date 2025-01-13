if status is-interactive
  # enable vi mode
  # fish_vi_key_bindings

  # vars
  export FZF_DEFAULT_COMMAND='rg --files --hidden --ignore-file ~/.ignore'
  # Aliases
  alias lg=lazygit
  alias ld=lazydocker
  alias p=python3
  alias vim='nvim'
  alias sshus='ssh -o StrictHostKeyChecking=no'
  alias ll="ls -l --color=auto"
  alias la="ls -la --color=auto"
  alias ls='ls --color=auto'
  alias ..='cd ..'
  alias rlf='readlink -f'
  # alias vn="NVIM_APPNAME=neorg nvim ~/notes/test.norg"
  alias vn="NVIM_APPNAME=neorg nvim ~/notes/"
  alias please="eval sudo (history -1 | string trim)"
  alias c="cd ~/code/(ls -1 ~/code/ | fzf)"
  alias cr="cat ~/notes/commands.norg | fzf | pbcopy"


  # FZF config
  # excludes are handled via $HOME/.ignore
  # Search for files with ctrl+f
  fzf_configure_bindings --directory=\cf

  # Accept next suggested word with CTRL-N
  bind -M insert \cN forward-bigword
  # Accept the entire suggestion with CTRL-U
  bind -M insert \cU accept-autosuggestion

  # Docker attach 
  function dsh
    docker container exec -it $argv[1] /bin/bash
  end

  function org
      set MODULE $argv[1].norg
      set -x NVIM_APPNAME neorg
      cd ~/notes/
      nvim $MODULE
  end

  zoxide init fish | source

  # set Jenkins ENV vars
  source ~/.set_jenkins_env_vars.sh

end
uv generate-shell-completion fish | source
uvx --generate-shell-completion fish | source
