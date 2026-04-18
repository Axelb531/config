set -gx GPG_TTY (tty)


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

# opencode
fish_add_path /Users/axel/.opencode/bin
