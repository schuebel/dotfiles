if status is-interactive
  # enable vi mode
  # fish_vi_key_bindings

  # vars
  export FZF_DEFAULT_COMMAND='rg --files --hidden --ignore-file ~/.ignore'
  # Aliases
  alias vc='nvim -c "lua require(\'nvim-possession\').list()"'
  alias lg=lazygit
  alias ld=lazydocker
  alias p=python3
  alias vim='nvim'
  alias sshus='ssh -o StrictHostKeyChecking=no'
  alias ll="ls -l --color=auto"
  alias la="ls -la --color=auto"
  alias ls='ls --color=auto'
  alias ..='cd ..'
  alias wttr='curl wttr.in/st-leon-rot'
  alias wttr2="curl -s 'wttr.in/st-leon-rot?format=v2'"
  alias sampler='sampler --config ~/.config/sampler/config.yml'
  alias g='git'
  alias rlf='readlink -f'

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

  zoxide init fish | source

end
