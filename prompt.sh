# default to current directory
function dir_git_branch() {
  # save current directory
  local mydir=$(pwd)
  # default branch ""
  local mydir_git_branch=""

  # if argument exists (is not a null string), change directory
  if [[ ! -z "$1" ]]; then
    cd $1
  fi

  # Based on: http://stackoverflow.com/a/13003854/170413
  local branch
  if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
    if [[ "$branch" == "HEAD" ]]; then
      branch='detached*'
    fi
    mydir_git_branch="($branch)"
  fi

  # if argument exists (is not a null string)
  if [[ ! -z "$1" ]]; then
    # go back
    cd $mydir
  fi

  # return variable
  echo $mydir_git_branch
  return 0
}

# default to current directory
function dir_git_dirty() {
  # save current directory
  local mydir=$(pwd)
  local mydir_git_dirty=""

  # if argument exists (is not a null string), change directory
  if [[ ! -z "$1" ]]; then
    cd $1
  fi

  local status=$(git status --porcelain 2> /dev/null)
  if [[ "$status" != "" ]]; then
    mydir_git_dirty='*'
  fi

  # if argument exists (is not a null string)
  if [[ ! -z "$1" ]]; then
    # go back
    cd $mydir
  fi

  # return variable
  echo "$mydir_git_dirty"
  #return 0
}

find_git_branch() {
  git_branch=$(dir_git_branch)
  #return 0
}

find_git_dirty() {
  git_dirty=$(dir_git_dirty)
  #return 0
}

find_git_watched() {
  # save current directory
  local mydir=$(pwd)
  local dirty=''
  local branch=''
  local mylabel=''
  local mypath=''
  local return_something=0
  local mygit_watched=''
  local separator=''
  git_watched=''

  for label_path in ${watchlist[@]}; do
    IFS=';' read -a arr <<< "$label_path"
    mylabel="${arr[0]}"
    mypath="${arr[1]}"

    # continue if $path is not a dir
    if [[ ! -d "$mypath" ]]; then continue; fi

    # if $path is current dir, set return_something and continue
    if [[ "$mydir" = "$mypath" ]]; then
      return_something=1
      continue
    fi

    # check if dirty
    dirty=$(dir_git_dirty "$mypath")

    # if dirty, process string
    if [[ ! -z "$dirty" ]]; then
      branch=$(dir_git_branch "$mypath")
      mygit_watched="${mygit_watched}${separator}${mylabel}:${branch}${dirty}"
      separator=', '
    fi
  done

  if [[ $return_something -eq 1 ]] && [[ ! -z "${mygit_watched}" ]]; then
    git_watched="[${mygit_watched}]"
  fi
}

PROMPT_COMMAND="find_git_branch; find_git_dirty; find_git_watched; $PROMPT_COMMAND"

# Default Git enabled prompt with dirty state
# export PS1="\u@\h \w \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

# Another variant:
# export PS1="\[$bldgrn\]\u@\h\[$txtrst\] \w \[$bldylw\]\$git_branch\[$txtcyn\]\$git_dirty\[$txtrst\]\$ "

# Default Git enabled root prompt (for use with "sudo -s")
# export SUDO_PS1="\[$bakred\]\u@\h\[$txtrst\] \w\$ "
