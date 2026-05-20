# Adjust error for GPG agent
set -gx GPG_TTY (tty)

export GPG_TTY=(tty)

# Personal aliases
function cd_up
    set levels $argv[1]

    if test -z "$levels"
        echo "Usage: cd_up <n>"
        return 1
    end

    set path (string repeat -n $levels "../")
    cd $path
end

abbr -a cd.. cd_up

alias zed="open -a /Applications/Zed.app -n"

alias civenso="cd ~/Developer/civenso-chatbot-api"

alias python=python3

alias pip=pip3

alias note='fish -c ~/Notes/createDailyNote.fish'

alias docekr=docker

alias ll='ls -l'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/axel/Downloads/google-cloud-sdk/path.fish.inc' ]
    . '/Users/axel/Downloads/google-cloud-sdk/path.fish.inc'
end
