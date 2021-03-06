![Build Status](https://travis-ci.org/creacominc/connectiq-PowerField.svg?branch=master)  Continuous Integration at: (https://travis-ci.org/creacominc/connectiq-PowerField)

Unit tests:  https://github.com/creacominc/connectiq-PowerFieldTests  ![Build Status](https://travis-ci.org/creacominc/connectiq-PowerFieldTests.svg?branch=master)  Continuous Testing at: (https://travis-ci.org/creacominc/connectiq-PowerFieldTests)


# connectiq-PowerField
A data field for Edge devices that shows heart rate, cadence, and 7 average power values, peaks, and targets.



# Purpose:  
This data field displays the current, average, and maximum for your heart rate and cadence at the top of the field.  Under these it shows the current, average, peak, and target power for each of seven time intervals.  The current and peak (or target for the small-screen layout) will change colour to indicate your current state for that time period.
 Rows with no average or peak power are time periods that have not yet been completed.
 A Row with a less-than before the time interval (eg "<20m") is showing values for the entire ride since that time interval exceeds the ride time so far.
 Rows above the incomplete row show the average for the last N seconds or minutes and the peak power for that interval.  
 Values for incomplete times are displayed in a dark grey.  
 Values for completed times that do not exceed 80% of the target are displayed in black or white depending on the background.
 If the data exceeds 80% of the set target, the average and peak power show as red or orange.
 If the data exceeds the target, it will display as blue.
 
The time intervals for each row can be set in Garmin Express or from your phone in seconds for up to two hours (7200 seconds).
If you find the four-column display hard to read, you can select a small-screen layout which shows three columns in larger fonts.  The third column can be toggled between the Target Power and the Peak Power by tapping on the data field.  (Testing with a Garmin 1000 has shown that this brings up the Home button and other overlays but they can be dismissed with a second tap.)  

This data field is intended to be used to achieve two goals:
 When using Best Bike Split or when trying to keep your Variability Index low, you need to target a power level and hold to it.  Using this screen you can maintain a relatively constant power over varying terrain to keep your VI low.
 You can set targets for an event or goals that you want to beat by entering the time and the power output you want to achieve for that time. 
 

# Resources:
- The field can be downloaded from https://apps.garmin.com/en-US/apps/ae433c7a-d706-4f80-8e29-f64e3fc4add4
- The source code can be seen at https://github.com/creacominc/connectiq-PowerField
- Unit tests for the field are at https://github.com/creacominc/connectiq-PowerFieldTests
- Comments, suggestions, and feedback are welcome and can be entered in the Garmin Forum at: https://forums.garmin.com/forum/developers/connect-iq/connect-iq-showcase/1253838-powerfield-comments-questions-and-suggestions-welcomed


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

Done:  Fixed a bug that caused the app to crash when the maximum time elapsed.

Done:  Only display the average for a time period that has passed or the overall average for a time period that is next to be passed.  For example, if the time periods are 5 and 20 minutes, until 5 minutes has passed, do not show the overall average on the 20 minute line.  Once the 5 minutes has passed and is showing the last 5 minutes, the 20 minute line can show the overall average time until 20 minutes passes.

Done:  add unit tests for times in excess of the upper limit.  Also fixed the issue that caused the average to be incorrect when the max time exceeded.

TBD:  Add configuration options for the colours and for showing large vs small font layout.


