source ~/.giterminal/helpers/colors.sh

if bash --version | grep -q darwin 
then 
	# MacOS
	if ! command -v fswatch &> /dev/null
	then
			echo "$(cyan fswatch) could not be found. Please install 'fswatch'"
			exit
	fi
	fswatch -xrL ./* |
		while read file event; do
			./installer.sh
		done
else
	# Linux
	if ! command -v inotifywait &> /dev/null
	then
			echo "$(cyan inotifywait) could not be found. Please install 'inotify-tools'"
			exit
	fi
	inotifywait -m ./* -e close_write |
		while read dir action file; do
			./installer.sh
		done
fi
