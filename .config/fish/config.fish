if status is-interactive
    # Commands to run in interactive sessions can go here
end
# Personal Aliases

alias docekr docker

alias ls "ls -l"

function ai 
	set -l prompt (string join " " $argv)
	set prompt (string replace -ra '"' '\\"' -- $prompt)
	ollama run mistral:v0.2 "$prompt"
end 

set -gx GPG_TTY (tty)

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
    eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
        . "/opt/homebrew/Caskroom/miniconda/base/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/opt/homebrew/Caskroom/miniconda/base/bin" $PATH
    end
end
# <<< conda initialize <<<


# Setting PATH for Python 3.12
# The original version is saved in /Users/axel/.config/fish/config.fish.pysave
set -x PATH "/Library/Frameworks/Python.framework/Versions/3.12/bin" "$PATH"

function envsource
  for line in (cat $argv | grep -v '^#')
    set item (string split -m 1 '=' $line)
    set -gx $item[1] $item[2]
    echo "Exported key $item[1]"
  end
end
