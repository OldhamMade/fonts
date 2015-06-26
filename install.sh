#!/bin/bash

USAGE=$(cat <<EOF
Install powerline fonts.

Options:

    -H=/--home=<dir>    the \$HOME directory to use (currently $HOME)

EOF
)

# Set source and target directories
powerline_fonts_dir=$( cd "$( dirname "$0" )" && pwd )

find_command="find \"$powerline_fonts_dir\" \( -name '*.[o,t]tf' -or -name '*.pcf.gz' \) -type f -print0"

TARGET=$HOME

for i in "$@"
do
case $i in
    -h|--help)
    echo "$USAGE"
    exit
    ;;
    -H=*|--home=*)
    TARGET="${i#*=}"
    shift # past argument=value
    ;;
    *)
    # unknown option
    ;;
esac
done

if [[ `uname` == 'Darwin' ]]; then
  # MacOS
  font_dir="$TARGET/Library/Fonts"
else
  # Linux
  font_dir="$TARGET/.fonts"
  mkdir -p $font_dir
fi

echo "About to install Powerline fonts to: $font_dir"

read -p "Do you wish to continue? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -n "Installing..."

    # Copy all fonts to user fonts directory
    eval $find_command | xargs -0 -I % cp "%" "$font_dir/"

    # Reset font cache on Linux
    if [[ -n `which fc-cache` ]]; then
        fc-cache -f $font_dir
    fi
    echo " done."

    echo "All Powerline fonts installed to $font_dir"
fi
