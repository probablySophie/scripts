#!/bin/bash

files=(./*)
dockerfiles=()
for ((i=0; i<${#files[@]}; i++)); do
	if [[ "${files[$i]}" == *.dockerfile ]]; then
		dockerfiles+=("${files[$i]}")
	fi
done

printf "We're going to build a docker container!\n"
printf "Please select a container: \n"

for ((i=0; i<${#dockerfiles[@]}; i++)); do
	printf "\t%-2s ${dockerfiles[$i]}\n" $i;
done

printf "\n> "
read file_num

if [[ $file_num == "q" ]]; then
	return 0
fi

chosen_file="${dockerfiles[$file_num]}"
printf "You chose: $chosen_file\n\n"

# Everything after the /
default_name=${chosen_file##*'/'}
# Everything before the '.dockerfile'
default_name=${default_name%%'.dockerfile'*}
# And swap _ for /
default_name=${default_name/_/\/}

printf "please enter the image name to use [$default_name]:\n> "
read name

if [[ "$name" == "" ]]; then
	name=$default_name
fi

printf "Building $chosen_file with the name $name"

if command -v podman &> /dev/null; then
	podman build -t $name -f $chosen_file .
else
	docker build -t $name -f $chosen_file .
fi
