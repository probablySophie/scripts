
# Check if folders have git changes

function __do_the_thing
{
	local files=(*);
	local filepath="";
	
	printf "These folders have local unpushed changes:\n";
	
	for file in "${files[@]}"; do
		filepath="$(pwd)/$file";

		if [[ -f "$filepath" ]]; then
			continue
		fi
		if [[ ! -d "$filepath/.git" ]]; then
			continue
		fi
		if [[ "$(git -C "$(pwd)/$file" status --porcelain --untracked-files=no)" ]]; then
			printf "\t$file\n"
		fi	
	done
}
__do_the_thing
unset __do_the_thing
