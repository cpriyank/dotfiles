# Borrowed from a stackoverflow link which is not dead
checkPath () {
  case ":$PATH:" in
    *":$1:"*) return 1
      ;;
  esac
  return 0;
}

# Prepend to $PATH
prependToPath () {
  for a; do
    checkPath "$a"
    if [ $? -eq 0 ]; then
      PATH=$a:$PATH
    fi
  done
  export PATH
}

# Append to $PATH
appendToPath () {
  for a; do
    checkPath "$a"
    if [ $? -eq 0 ]; then
      PATH=$PATH:$a
    fi
  done
  export PATH
}
