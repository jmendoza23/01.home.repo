# 01.home.repo
"Control the size of the file. If the file reaches the size of 1 MiB 
interrupt the creation of more random lines." 

To me this was the main objective, how write random data in a file but keeping an eye of the file size and exit the script when reach a specific size. 

Using command "ls -l" will return the size of the file in bytes, then I assign this to a variable (counter). I tought this could be the solution but I faced with an error that was not able to resolved. Besides "ls -l" I need to use something else to obtain only the size value as no other value was need it, I tried to pipe awk '{print $5}' but $5 was recognized by bash as an argument and this expected a value when ran the script and broke the script, I was not able to tell the script that $5 its not an argument but an option of awk.
My second option was use "stat" command and try to obtain the size value with "cut" but there is an option using --print that gives the value in bytes "%s", other option is use "du".

With this variable and the specific limit size I decided to use a while cycle to write in a file lines of random data (alphanumeric) obtained from "/dev/urandom", using "tr" I get desired characters (a-zA-Z0-9) and with 
"head" I obtained the 15th first characters to limit the string, cycle will be working while file is lower or equal than max size and exit once this stop to be truth. In my first tries I was able to limit the size of the file and random data was printed in file but script was not able to write line by line so I added a jumpline that will be added after the 15 random characters, as blank lines appear I added "awk" to remove blank spaces of the file and overwrite data in a new file, with this new file I decided to use a temp file and left two main files with the results. 

One file will be the result of the random characters line by line without blank lines and second one will have the output of the "sort" command in my case I used a reverse option and if  sort is used without any option will sort from numbers to letters in descendent order also this file will have the result of remove lines that begin with a-A characters from the first file.
