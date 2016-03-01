# CMS Version Checker

## Use
This isn't an executable file yet, so you'll need to run commands in the Tcl shell. Tcl is probably already installed on your server (and it comes pre-installed on Mac OSX as well).

* Open up a terminal and cd to to the directory of accounts, like your home directory on a server, or your htdocs or sites directory on your local machine.
* Type "tclsh" to begin the Tcl shell. The prompt should be a percent sign (%)
* Paste everything from "set count 0" to the end (We won't be using proc printOut, so that bit isn't important)
* You should see messages on your terminal as it goes through the directories. It may stop before hitting the full count number (suffixed by -ish) since not all directories are necessarily accounts.
* A CSV formatted variable will have been created, so type "puts $CSV" and you should get a nice printout on the terminal screen. Not ideal, but it's a good start!
* Copy and paste the CSV into a file somewhere else, and import into Google Sheets, Excel, Numbers, or whatever else for sorting. Or parse it with another script!

## Notes
This was written quickly, and there's lots of room for improvement.

Currently, the script's not set up to be executable. Feel free to add the proper shebang to the top of the file, put it in the directory you like, and chmod u+x so it can be executed. It'll also be nice to write out to a proper CSV file instead of setting a variable. Also, we're not going through directories recursively, so if your CMS isn't in the top-level account directory and is somewhere else, e.g., accountname/blog/, the script won't find anything.

A future update could also involve handling SSH-ing into each server so the script can be run from anywhere, and would ultimately return a .CSV file in the same directory. That would be sweet, but I can only sink so much time into this, haha.

If you just need version numbers quickly, you can string together a few bash commands. From [this site](https://kb.iweb.com/entries/29801848-Verifying-CMS-versions-on-multiple-websites), try something like these:

# Get Wordpress versions
find /home/*/public_html/ -type f -iwholename "*/wp-includes/version.php" -exec grep -H "\$wp_version =" {} \;
# Get Drupal versions
find /home/*/public_html/ -type f -iwholename "*/modules/system/system.info" -exec grep -H "version = \"" {} \;
# Get CMSMS verisons
find /home/*/public_html/ -type f -iwholename "*/version.php" -exec grep -H "\$CMS_VERSION = \"" {} \;
