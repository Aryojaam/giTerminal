if ! command -v inotifywait &> /dev/null
then
    echo "Command 'inotifywait' could not be found. Please install 'inotify-tools'"
    exit
fi
inotifywait -m ./* -e close_write |
	while read dir action file; do
		./installer.sh
	done
