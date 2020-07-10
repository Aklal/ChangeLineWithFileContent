#!/bin/bash -
set -o nounset

function replaceTextWithFile() {
    # File to modify (in production the name is passed as an argument)
    local originalFile="./file.txt"

    # Regex to find the line to change
    local regex="<iframe src=\"(https:\/\/foo.*)\" frameborder"
    # Regex on "normal" line does not work neither
    #local regex="^oportu.*"

    # The file whose content must replace the line
    local replacementFile="./new_content"

    exec 4<"$originalFile"
    while read line <&4 ; do
        if [[ $line =~ $regex ]];then
            echo "PATTERN FOUND"
            sed -i '' -e '/$line/r $replacementFile' -e '//d' $originalFile

            #https://stackoverflow.com/a/38782644
            # Does not work
            #sed -i '' -E '/$line/r $replacementFile' $originalFile
        fi

        # Following command changes the 9th line successfully
        #sed -i '' -e "9s/.*/TEST TEST/" $originalFile

        #the 9th line is replaced by "r $replacementFile"
        #sed -i '' -e '9s/.*/r $replacementFile/' $originalFile

        content=$(cat $replacementFile)
        #the 9th line is replaced by "$content"
        #sed -i '' -e '9s/.*/"$content"/' $originalFile
        #the 9th line is replaced by $content
        #sed -i '' -e '9s/.*/$content/' $originalFile

        # Try to escape particular characters in the line to replace
        line2="\<iframe src=\"https:\/\/foo\.com\/bar\/11d75d1c66667299e4fe35e\" frameborder=0\>\<\/iframe\>"
        #sed -i '' -e '/$line2/r $replacementFile' -e '//d' $originalFile

        # Try other syntax
        #sed -i '' -e '/"$line2"/r $replacementFile' -e '//d' $originalFile

        #sed -i '' -e '/${line2}/${content}' -e '//d' $originalFile

        #https://stackoverflow.com/a/22041386
        # Does not change anything
        #sed -i '' '/$line2/r $replacementFile' $originalFile

        #https://stackoverflow.com/a/22041386
        # Does not change anything
        #sed -i '' '/${line2}/r $replacementFile' $originalFile

        # Try other syntax
        #content=$(cat $replacementFile)
        #echo "$content"
        # Raise error: sed: 1: "/"$line2"/$content": invalid command code $"
        #sed -i '' -e '/"$line2"/$content' -e '//d' $originalFile
    done
    exec  4<&-
}

replaceTextWithFile