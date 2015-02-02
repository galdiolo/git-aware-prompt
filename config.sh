# check if bash supports arrays (array support is recent)
check[0]='check' || (echo 'Error: this version of bash does not support arrays.' && exit 2)

# directories to watch
# - sometimes it's useful to watch the status of other repositories
#
# separate label and path with a ";"
# example: label;path
watchlist=(
#    "myapp;/Users/cgaldiolo/myapp"
#    "themes;/Users/cgaldiolo/myapp/themes"
#    "shared;/Users/cgaldiolo/shared"
    )