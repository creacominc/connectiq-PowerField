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
