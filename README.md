# Update-hedns.sh

Bash script to update dynamic zone hosted at Hurricane Electric. 

Step 1: Create a dynamic zone with TTL 300 using the HE web interface. 

Step 2: Set a key to update the dynamic zone (a.k.a password)

Step 3: Change the domain and password parameters on the shell script.

Step 4: Make the script executable

`# chmod a+x update-hedns.sh`

Step 4: Set up a cronjob to check and update the IP periodically 

e.g. hourly

`1 * * * * /usr/local/bin/update-hedns.sh >> /dev/null 2>&1`


 