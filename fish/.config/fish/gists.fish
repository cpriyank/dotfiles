# Creates a new gist from a file and copies its raw URL to the clipboard
function gcreate --description "Create a gist and copy its raw URL"
    set file_path $argv[1]
    if not test -f "$file_path"
        echo "File not found: $file_path"
        return 1
    end

    # Create the gist and capture its public URL
    set gist_url (gh gist create "$file_path" --secret)
    if test $status -ne 0
        echo "Failed to create gist."
        return 1
    end

    # Extract the Gist ID from the URL (last part after /)
    set gist_id (string split '/' $gist_url | tail -n 1)

    # Get the filename for precise lookup
    set filename (basename $file_path)

    # Get the raw URL using the filename key
    set raw_url (gh api "gists/$gist_id" | jq -r --arg fn "$filename" '.files[$fn].raw_url' 2>/dev/null)
    if test -z "$raw_url" -o "$raw_url" = "null"
        echo "Failed to retrieve raw URL for filename: $filename"
        return 1
    end

    # Copy the raw URL to the clipboard
    echo -n $raw_url | pbcopy

    echo "Gist created: $gist_url"
    echo "Raw URL copied to clipboard: $raw_url"
end

function gedit --description "Edit a gist and copy its raw URL"
    set gist_id $argv[1]
    if test -z "$gist_id"
        echo "Usage: gedit <gist_id>"
        return 1
    end

    # Open the gist in your configured editor
    gh gist edit $gist_id
    if test $status -ne 0
        echo "Gist editing cancelled."
        return 1
    end

    # Brief pause for API propagation (optional; increase if caching is an issue)
    sleep 2

    # Get the raw URL using iterator for any single-file gist (post-edit)
    set raw_url (gh api "gists/$gist_id" | jq -r '.files[] | .raw_url' | head -n1 2>/dev/null)
    if test -z "$raw_url" -o "$raw_url" = "null"
        echo "Could not retrieve raw URL for gist $gist_id after edit. Check gh auth or gist access."
        return 1
    end

    # Copy the raw URL to the clipboard
    echo -n $raw_url | pbcopy

    echo "Gist updated successfully."
    echo "Raw URL copied to clipboard: $raw_url"
end
