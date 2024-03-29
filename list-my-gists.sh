#!/bin/bash

public_only=0
secret_only=0
public_and_secret=0
signature=1

while test $# -gt 0; do
    case "$1" in
        --public-only) public_only=1
            ;;
        -p) public_only=1
            ;;
        --secret-only) secret_only=1
            ;;
        -s) secret_only=1
            ;;
        --public-and-secret) public_and_secret=1
            ;;
        -ps) public_and_secret=1
            ;;
        --no-signature) signature=0
            ;;
        *)
            echo $'Usage: list-my-gists [options...]

Options:
 -p,  --public-only         Create (or update) a public list of my public gists (default enabled)
 -s,  --secret-only         Create (or update) a secret list of my secret gists (default enabled)
 -ps, --public-and-secret   Create (or update) a secret list of my public & secret gists
      --no-signature        Do not include signature in the gist created
'
            exit 0
            ;;
    esac
    shift
done

if [ $public_only -eq 0 ] && [ $secret_only -eq 0 ] && [ $public_and_secret -eq 0 ]; then
    public_only=1
    secret_only=1
fi

my_gists=$(gist -l)

if [ $? -ne 0 ]; then
    echo "$my_gists"
    exit 1
fi

my_gists=$(echo "$my_gists" | sort -k 2 -f | sed 's/\[/\\[/g' | sed 's/\]/\\]/g')

my_public_gists=$(echo "$my_gists" | grep -v ' (secret)$' | sed -E 's/^(.*\.github\.com\/)([^ ]+) (.*) $/- [\3](\1\2)/')
my_secret_gists=$(echo "$my_gists" | grep ' (secret)$' | sed -E 's/^(.*\.github\.com\/)([^ ]+) (.*) \(secret\)$/- [\3](\1\2)/')

generate_output() {
    output=''
    if [ "$1" == "public-only" ]; then
        type='public'
        gist_option=''
        title='My gists'
        filename='my-gists.md'
        hash=$(echo "$my_gists" | grep 'My gists *$' | sed -n 1p | sed -E 's/.*\.github\.com\/([^ ]+) .*/\1/')

        [ ! -z "$my_public_gists" ] && output+=$'## My gists\n'"$my_public_gists"$'\n\n'
    elif [ "$1" == "secret-only" ]; then
        type='secret'
        gist_option='-p'
        title='My secret gists'
        filename='my-secret-gists.md'
        hash=$(echo "$my_gists" | grep 'My secret gists (secret)$' | sed -n 1p | sed -E 's/.*\.github\.com\/([^ ]+) .*/\1/')

        [ ! -z "$my_secret_gists" ] && output+=$'## My secret gists\n'"$my_secret_gists"$'\n\n'
    else
        type='public & secret'
        gist_option='-p'
        title='My public & secret gists'
        filename='my-public-and-secret-gists.md'
        hash=$(echo "$my_gists" | grep 'My public & secret gists (secret)$' | sed -n 1p | sed -E 's/.*\.github\.com\/([^ ]+) .*/\1/')

        [ ! -z "$my_public_gists" ] && output+=$'## My public gists\n'"$my_public_gists"$'\n\n'
        [ ! -z "$my_secret_gists" ] && output+=$'## My secret gists\n'"$my_secret_gists"$'\n\n'
    fi
    [ $signature == 1 ] && output+=$'## Generated by\n[list-my-gists](https://github.com/cslee/list-my-gists)\n'

    if [ -z "$hash" ]; then
        echo 'Creating My '$type' gists...'
        echo "$output" | gist $gist_option -d """$title""" -f $filename
    else
        echo 'Updating My '$type' gists...'
        echo "$output" | gist -u $hash -f $filename
    fi
    echo $'Done\n'
}

[ $public_only -eq 1 ] && [ ! -z "$my_public_gists" ] && generate_output 'public-only'
[ $secret_only -eq 1 ] && [ ! -z "$my_secret_gists" ] && generate_output 'secret-only'
[ $public_and_secret -eq 1 ] && [ ! -z "$my_gists" ] && generate_output 'public-and-secret'

exit 0
