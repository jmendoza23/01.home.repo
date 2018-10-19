#! /bin/bash
#
# Variables, files and temp file.
#
TEMP_FILE=$(mktemp /tmp/tempfile.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX)
FILE_NAME=/tmp/test.log
FILE_NAME_LAST=/tmp/test_last.log
MAX_SIZE_FILE=1048576
FILE_SIZE=1
LINE_COUNT_FN=0
LINE_COUNT_FL=0
LINE_COUNT_TOTAL=0
#
# None argument its required for this script.
#
[ $# -gt 0 ] && echo "Usage: No arguments are required, try again..." && exit 1
#
# First time the script will run directly to create file but if it was ran previously the script will remove 
# files (FILE_NAME and FILE_NAME_LAST) and then will create the random strings.
#
if [ -f $FILE_NAME ] && [ -f $FILE_NAME_LAST ]; then
    echo "File found it, removing..." && rm $FILE_NAME && rm $FILE_NAME_LAST
    echo "File was removed, Starting work...."
else
    echo "Working.."
fi
#
# while FILE_SIZE is lower or equal MAX_SIZE_FILE, script will obtain  15 characters (alphanumeric) from /dev/urandom and insert to the TEMP_FILE, 
# create a blank space that will be removed after cicle ends.
# Script will get in each iteration the size of the TEMP_FILE and add result to the FILE_SIZE variable.
#
while  [ $FILE_SIZE -le $MAX_SIZE_FILE ]
do
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c15 >> $TEMP_FILE
    echo -e "\n" >> $TEMP_FILE
    FILE_SIZE=$(stat --printf="%s" $TEMP_FILE)
done
#
# Script will remove all blank lines and write result in FILE_NAME, sort will be used to show data in ascendent order (Z...0) and all lines with [a-A] character at the begining will be removed,
# this output will be writen in FILE_NAME_LAST, for the last will obtain the number of lines that were removed.
#
echo "File reach MAX SIZE"
echo "Still working..."
awk NF $TEMP_FILE >> $FILE_NAME
sort -ro $FILE_NAME $FILE_NAME
LINE_COUNT_FN=$(wc -l $FILE_NAME | cut -d' ' -f1)
less $FILE_NAME | grep -v -e "^[a:A]" > $FILE_NAME_LAST
echo "Sorting file...."
sort $FILE_NAME >> $FILE_NAME
LINE_COUNT_FL=$(wc -l $FILE_NAME_LAST | cut -d' '  -f1)
let LINE_COUNT_TOTAL=( $LINE_COUNT_FN - $LINE_COUNT_FL )
echo "Total Line Count removed were: $LINE_COUNT_TOTAL"
echo "---------------------"
# rm -vf $TEMP_FILE* &> /dev/null
echo "Work Completed!!!"
echo "---------------------"
exit 0
