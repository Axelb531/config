function print_repo
    # Check if the correct number of arguments are provided
    if test (count $argv) -ne 1
        echo "Usage: print_repo <wildcard_pattern>"
        return 1
    end

    # Assign the argument to a variable
    set pattern $argv[1]

    # Check if .gitignore exists in the current directory
    if test -f .gitignore
        # Get the list of Git-tracked files and directories
        set git_files (git ls-files --directory)
        set git_dirs (git ls-tree -d -r --name-only HEAD)
        set search_dirs $git_files $git_dirs
    else
        # Search the entire directory if .gitignore doesn't exist
        set search_dirs "."
    end

    # Initialize content with the git ls-files output
    set git_files_list (git ls-files)
    set content "Git tracked files:\n$git_files_list\n\n"

    # Maximum buffer size (in characters)
    set max_buffer_size 1000000

    # Append the content of each matching file to the content variable
    for dir in $search_dirs
        set filelist (find $dir -type f -name $pattern)
        for file in $filelist
            set file_content (cat $file)
            set content "$content===== $file =====\n$file_content\n\n"

            # Check if content size is approaching typical clipboard limits (~1MB)
            if test (string length $content) -gt $max_buffer_size
                echo "Content is too large to fit in clipboard. Truncating output."
                break
            end
        end
    end

    # Copy the content to the clipboard
    echo $content | pbcopy

    echo "Git tracked files and content of matching files copied to clipboard."
end
