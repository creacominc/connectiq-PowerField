# connectiq-PowerField
A data field for Edge devices that shows heart rate, cadence, and 7 average power values, peaks, and targets.



# Purpose:  

When using Best Bike Split or when trying to keep your Variability Index low, you need to target a power level and hold to it.  The end goal of this screen will be to show the key metrics needed while riding with the goal of "constant power over varying terrain".

# Build Phases:
0) [Done] Initial functional release.  This is ugly, but it works.  It takes up too much memory, the code is poorly written, and the limits are hard-coded.  But I wanted to use my new 1030 and the field I was using on my 1000 is not available yet. 

1) [Done] Clean-up of display.   In the next phase I plan to get the display to look reasonable so that it is easier to read.

2) [Done] Configuration integration.  The targets should be configurable.  I need to get them from a screen on the phone or from Garmin Connect.

3) [Done] Addition of colour.  I plan to add colour either to the font or as a progress-bar behind the numbers to indicate your current power and your peak power in relation to your goal.

4) [Done] Initial release on Garmin Connect.

5) [Done] Improve efficiency.  Right now I have a collection for each of the time periods.  This is not needed.  I plan to change the design so that each time period only has offset references into one collection.  That collection needs to be the size of the largest time period, but only one tmie period is needed.

# Next Steps:
This only works on a few devices that have sufficient memory.  I would like it to work on the Vivoactive HR, the Forerunner 920XT, and the Fenix 5x but testing with the simulator shows that it exceeds the memory limits. If I can reduce the memory usage and improve the efficiency, I will enable these devices.

TBD:  To reduce the memory footprint (after I test it on other devices), I will reduce the precision and the memory used by having three storage arrays.  A per-second array for the last 120 seconds, grouping data into 30 second chunks and storing in a second array for 5 and 20 minute averages, and grouping them in 5 minute chunks into another array for the 1 and two hour averages.  This should reduce the data from 7200 entries to 184.  This will mean losing the option for the user to configure the time periods as they need to be multiples of 1 second for up to 120 seconds, 30 seconds for up to 20 minutes, and multiples of 5 minutes for any longer times.  I could generate the list of usable values but it is probably simpler to just fix them at 3s, 30s, 2mins, 5mins, 20mins, 1hr, and 2hr.

Done:  Remove the decimal place on the time.

Done:  change the colours to avoid green and red and to provide a dark colour when the backgound is light.

Done:  Change the average computation for unexpired times so that they reflect the average and peak power so far.




