inotifywait -m ./* -e close_write |
	while read dir action file; do
		./installer.sh
	done
