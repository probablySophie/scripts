function __git_pull_all
{
	local files=(*);
	local filepath="";
	local errors=();
	for file in "${files[@]}"; do
		filepath="$(pwd)/$file";
		if [[ -f "$filepath" ]]; then
			printf "\033[7m$file\033[0m is a file so cannot be a git repo, skipping\n";
			continue
		fi
		if [[ ! -d "$filepath/.git" ]]; then
			printf "\033[7m$file\033[0m does not have folder .git inside, skipping\n";
			continue
		fi
		printf "\033[7m$file\033[0m "
		# printf "AAAA\n";
		if git -C "$(pwd)/$file" pull ; then
			printf "";
		else
			errors+=($file)
		fi
	done
	if [[ ${#errors[@]} > 0 ]]; then
		printf "${red}Failed to update:${normal}\n";
		for error in "${errors[@]}"; do
			printf "\t$error\n";
		done
	fi
}

__git_pull_all
unset __git_pull_all
