files=(*)
for file in "${files[@]}"; do
	printf "$(pwd)/$file\n"
	git -C "$(pwd)/$file" pull
done
