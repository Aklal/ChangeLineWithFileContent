#!/bin/bash -
set -o nounset

function replaceTextWithFile() {
    # File to modify (in production the name is passed as an argument)
    local originalFile="./file.txt"

    # Regex to find the line to change
    local regex="<iframe src=\"(https:\/\/test.*)\" frameborder"
    # Regex on "normal" line does not work neither
    #local regex="^oportu.*"

    # The file whose content must replace the line
    local replacementFile="./new_content"

    exec 4<"$originalFile"
    while read line <&4 ; do
        if [[ $line =~ $regex ]];then
            echo "PATTERN FOUND"

            reg=${BASH_REMATCH[1]}
            echo $reg
            #sed -i '' -e '/$line/r $replacementFile' -e '//d' $originalFile
            #sed -i '' -e '/$regex/r new_content' -e '//d' $originalFile
            #sed -i -e "/$regex/r $replacementFile" -e '//d' "$originalFile"

            #https://stackoverflow.com/a/38782644
            # Does not work
            #sed -i '' -E '/$line/r $replacementFile' $originalFile

            #https://stackoverflow.com/a/39467432/1286214
            #sed: 1: "s/^.*oportu.*$/LOREM IP ...": unescaped newline inside substitute pattern
            #sed "s/^oportu.*$/$(cat new_content)/" $originalFile

            # Output on stdout file with the line changed the line with: "$(cat new_content)"
            #sed 's/^oportu.*$/"$(cat new_content)"/' $originalFile
            # Output on stdout file with the line changed with: r $replacementFile
            #sed 's/^oportu.*$/r $replacementFile/' $originalFile

            #https://stackoverflow.com/a/39411657/1286214
            # Error sed: 1: "d}
                #": extra characters at the end of d command
            #sed -e '/^oportu.*$/{r new_content' -e 'd}' $originalFile

            # Output on stdout file with the line changed the line with: $(< new_content)
            #sed 's/^oportu.*$/$(< new_content)/' $originalFile

            #https://stackoverflow.com/a/39413525/1286214
            # Error: sed: 1: "d}
                #": extra characters at the end of d command
            #sed -e '/^oportu.*$/{r new_content' -e 'd}' $originalFile
        fi

        # Following command changes the 9th line successfully
        #sed -i '' -e "9s/.*/TEST TEST/" $originalFile

        #the 9th line is replaced by "r $replacementFile"
        #sed -i '' -e '9s/.*/r $replacementFile/' $originalFile

        #content=$(cat $replacementFile)
        #the 9th line is replaced by "$content"
        #sed -i '' -e '9s/.*/"$content"/' $originalFile
        #the 9th line is replaced by $content
        #sed -i '' -e '9s/.*/$content/' $originalFile

        # Try to escape particular characters in the line to replace
        #line2="\<iframe src=\"https:\/\/test\.com\/bar\/11d75d1c66667299e4fe35e\" frameborder=0\>\<\/iframe\>"
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

#Does not work
#replaceTextWithFile

#Work!!
#https://stackoverflow.com/a/62832384/1286214
replaceTextWithFile() {
    local originalFile="./file.txt"
    local regex="<iframe src=\"https:\/\/.*\" frameborder"
    local replacementFile="./new_content"
    sed -i '' -e "/$regex/r $replacementFile" -e '//d' "$originalFile"
}

replaceTextWithFile
