function __git_pull_all
{
	local files=(*);
	local filepath="";
	local errors=();
	local success=();
	local skipped=();

	local i=0;
	while [[ "${files[$i]}" != "" ]]; do
		local file="${files[$i]}";
		$(( i++ )) &> /dev/null;

		filepath="$(pwd)/$file";
		
		if [[ -f "$filepath" ]]; then
			# printf "\033[7m$file\033[0m is a file so cannot be a git repo, skipping\n";
			skipped+=($file)
			continue
		fi
		# Does the golder have a .git folder inside of it?
		if [[ ! -d "$filepath/.git" ]]; then
			printf "\033[7m$file\033[0m does not have folder .git inside, skipping\n";
			skipped+=($file)

			# This folder doesn't have a .git, but do its children have .git folders?
			local secondary_files=($filepath/*);
			for file2 in "${secondary_files[@]}"; do
				if [[ -f "$file2" ]]; then
					continue
				fi
				if [[ -d "$file2/.git" ]]; then
					files+=("${file2/"$(pwd)/"/}");
				fi
			done

			continue
		fi
		# Print the file name as black on white
		printf "\033[7m$file\033[0m "

		local command="git -C "$filepath" pull --recurse-submodules"
		if [[ "$1" == "push" ]]; then
			command="git -C "$filepath" push" 
		fi

		# Try & pull the folder
		if $command; then
		# if true; then
			success+=($file)
			# Success :)
		else
			errors+=($file)
			# Error :(
		fi
		printf "\n";
	done
	printf "\n\n";
	if [[ ${#skipped[@]} > 0 ]]; then
		printf "Skipped:\n";
		for item in "${skipped[@]}"; do
			printf "\t$item\n";
		done
	fi

	if [[ ${#success[@]} > 0 ]]; then
		printf "${green}Successes:${normal}\n";
		for item in "${success[@]}"; do
			printf "\t$item\n";
		done
	fi

	if [[ ${#errors[@]} > 0 ]]; then
		printf "${red}Failed to update:${normal}\n";
		for error in "${errors[@]}"; do
			printf "\t$error\n";
		done
	fi
}

__git_pull_all $1
unset __git_pull_all
