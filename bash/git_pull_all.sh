function __git_pull_all
{
	local files=(*);
	local filepath="";
	local errors=();
	local success=();
	local skipped=();
	for file in "${files[@]}"; do
		filepath="$(pwd)/$file";
		if [[ -f "$filepath" ]]; then
			printf "\033[7m$file\033[0m is a file so cannot be a git repo, skipping\n";
			skipped+=($file)
			continue
		fi
		if [[ ! -d "$filepath/.git" ]]; then
			printf "\033[7m$file\033[0m does not have folder .git inside, skipping\n";
			skipped+=($file)
			continue
		fi
		printf "\033[7m$file\033[0m "
		# printf "AAAA\n";
		if git -C "$(pwd)/$file" pull --recurse-submodules ; then
			success+=($file)
		else
			errors+=($file)
		fi
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

__git_pull_all
unset __git_pull_all
