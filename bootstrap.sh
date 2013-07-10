#!/bin/bash
cd "$(dirname "${BASH_SOURCE}")"
git pull
alias base-rsync='rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" --exclude "README.md" --exclude "init/"'
function doIt() {
	os=${OSTYPE//[0-9.]}
	if [[ "$os" == 'darwin' ]]; then
		base-rsync -av . ~
		cp init/private.xml ~/Library/Application\ Support/KeyRemap4MacBook/
	else
		base-rsync \
			--exclude ".aliases_osx" \
			--exclude ".slate" \
			-av . ~
	fi
}
if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi
unset doIt
unset base-rsync
source ~/.bash_profile
