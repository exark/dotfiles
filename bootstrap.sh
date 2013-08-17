#!/bin/bash
cd "$(dirname "${BASH_SOURCE}")"
git pull

function doIt() {
	os=${OSTYPE//[0-9.]}
	base_rsync='rsync --exclude ".git/*" --exclude ".DS_Store" --exclude "bootstrap.sh" --exclude "README.md" --exclude "init/"'
	if [[ "$os" == 'darwin' ]]; then
		rsync \
			--exclude ".git/" \
			--exclude ".DS_Store" \
			--exclude "bootstrap.sh" \
			--exclude "README.md" \
			--exclude "init/" \
			-av . ~
		cp init/private.xml ~/Library/Application\ Support/KeyRemap4MacBook/
	else
		rsync \
			--exclude ".git/" \
			--exclude ".DS_Store" \
			--exclude "bootstrap.sh" \
			--exclude "README.md" \
			--exclude "init/" \
			--exclude ".aliases_osx" \
			--exclude ".brew" \
			--exclude ".osx" \
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
source ~/.bash_profile
