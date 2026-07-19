
i=0;
for filename in ./*; do
	# Not a directory?  Ignore
	if [[ ! -d "$filename" ]]; then continue; fi
	# Not a git repo at all?  Ignore
	if [[ "$(git -C "$filename" rev-parse --show-toplevel 2>/dev/null)" == "" ]]; then continue; fi
	# No remote?  No pulling
	if [[ "$(git -C "$filename" remote -v 2>/dev/null)" == "" ]]; then continue; fi

	printf "$i $filename";

	if git -C "$filename" pull --recurse-submodules > /dev/null 2>&1; then
		printf " ${green}success";
	else
		printf " ${red}failed";
	fi
	printf "${normal}\n";

	i=$(( $i + 1 ));
done
