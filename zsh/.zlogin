# This file is read at login after zshrc
{
  # Compile the completion dump to increase startup speed.
  zcompdump="~/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!