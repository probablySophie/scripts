# From https://github.com/junegunn/fzf/wiki/examples#Emoji

EMOJI_URL="https://gist.githubusercontent.com/keidarcy/128141ff30a8c3f9ddc0d6c3ecb5b334/raw/8fc6b9efe6b72e8a876639e239043d492e857746/emoji.txt"
emoji="$(curl -sSL "$EMOJI_URL")";
selected_emoji="$(echo "$emoji" | fzf)"
echo "$selected_emoji"
