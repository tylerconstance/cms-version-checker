# Go through each directory on our server
# Currently this should be run
# Eventually this could be modified to SSH into each server

# WP check, Drupal check, CMSMS check in bash
# find /home/*/public_html/ -type f -iwholename "*/wp-includes/version.php" -exec grep -H "\$wp_version =" {} \;
# find /home/*/public_html/ -type f -iwholename "*/modules/system/system.info" -exec grep -H "version = \"" {} \;
# find /home/*/public_html/ -type f -iwholename "*/version.php" -exec grep -H "\$CMS_VERSION = \"" {} \;
# (https://kb.iweb.com/entries/29801848-Verifying-CMS-versions-on-multiple-websites)

# run from home directory as root in tclsh
# After finishing, puts $CSV prints output
set count 0
set versionList ""
set total 0
set CSV "client,CMS,version"

foreach dir [glob -type d *] {
  incr total
}
puts "Okay, let's begin."
foreach dir [glob -type d *] {
  puts "Looking at $dir..."
  if { [file isdirectory $dir/public_html] && $dir != "devdayibec" && $dir != "museum2"} {
    cd $dir/public_html
    # Try Drupal
    set version [exec drush status | head -1]
    if {[lindex $version 0] == "Drupal"} {
      puts "This one's Drupal"
      #lappend versionList "$dir: $version"
      #lappend drupalList "$dir: $version"
      # Version gives us something like NAME: X.X.X; all we care about is the last bit
      # Get the length and then take the item at the last index (remember, Tcl is zero-indexed)
      set length [llength $version]
      set version [lindex $version [expr $length - 1]]
      append CSV "\n$dir,Drupal,$version"
    } elseif { [file exists version.php] } {
      puts "Looks like CMSMS."
      set version [exec grep "^\$CMS_VERSION = .*;" version.php]
      # parse out the yucky bits
      regsub -all {"} $version "" version
      regsub -all {'} $version "" version
      regsub -all {;} $version "" version
      # lappend versionList "$dir $version"
      # lappend CMSMSList "$dir $version"
      set length [llength $version]
      set version [lindex $version [expr $length - 1]]
      append CSV "\n$dir,CMSMS,$version"
    } elseif { [file exists wp-includes/version.php] } {
      puts "Looks like Wordpress"
      set version [exec grep "^\$wp_version = .*;" wp-includes/version.php]
      # parse out the yucky bits – not sure if this is working
      regsub -all {"} $version "" version
      regsub -all {'} $version "" version
      regsub -all {;} $version "" version
      set length [llength $version]
      set version [lindex $version [expr $length - 1]]
      # lappend versionList "$dir $version"
      # lappend wpList "$dir $version"
      append CSV "\n$dir,Wordpress,$version"
    } else {
      puts "I can't recognize what's in $dir"
      # lappend versionList "$dir: unknown"
      # Want these in the CSV too?
      # append CSV "\n$dir,unknown,unknown"
    }

    cd ../..
    incr count
    puts "$count of $total-ish down ($dir)"
  }
}

# Not currently used
# proc printOut {versionList cmsName} {
#   foreach item $versionList {
#    set length [llength $item]
#    set name [lindex $item 0]
#    set version [lindex $item [expr $length - 1]]
#    puts "$name $cmsName $version"
#  }
