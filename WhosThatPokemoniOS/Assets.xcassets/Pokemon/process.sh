

for file in *.png
do
    #echo $file
    number=$(echo $file | grep -o '[0-9]*')
    filepath=$number.imageset
    rm -rf $number
    if [[ ! -e $filepath ]]; then
        mkdir $filepath
    fi
    touch $filepath/Contents.json
    mv $file $filepath

    cat <<EOT > $filepath/Contents.json
{
  "images" : [
    {
      "idiom" : "universal",
      "scale" : "1x"
    },
    {
      "idiom" : "universal",
      "filename" : "$number@2.png",
      "scale" : "2x"
    },
    {
      "idiom" : "universal",
      "filename" : "$number@3.png",
      "scale" : "3x"
    }
  ],
  "info" : {
    "version" : 1,
    "author" : "xcode"
  }
}
EOT

done

