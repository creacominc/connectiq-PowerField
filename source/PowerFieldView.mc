using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;

class PowerFieldView extends Ui.DataField
{
    protected const NUM_FIELDS = 7;
    protected enum
    {
        e_CUR,
        e_AVG,
        e_MAX
    }
    protected var m_TimerRunning = false;
    protected var m_hearts;
    protected var m_cadences;
    protected var m_elapsedTime;
    protected var m_columnLocations = [25, 50, 75, 100];

    protected var m_powerIntervalSet;

    function initialize()
    {
        DataField.initialize();
        m_hearts = [0, 0, 0];
        m_cadences = [0, 0, 0];
        m_elapsedTime = 0;
        m_powerIntervalSet = new PowerIntervalSet(NUM_FIELDS);
        // get the screen width for placing items
        var mySettings = System.getDeviceSettings();
        var screenWidth = mySettings.screenWidth;
        var columnWidth = screenWidth / 4;
        m_columnLocations[0] = columnWidth;
        m_columnLocations[1] = columnWidth * 2;
        m_columnLocations[2] = columnWidth * 3;
        m_columnLocations[3] = screenWidth;
    }


    //! Timer transitions from stopped to running state
    function onTimerStart()
    {
        if (!m_TimerRunning)
        {
            //var activityMonitorInfo = getActivityMonitorInfo();
            m_TimerRunning = true;
        }
    }

    //! Timer transitions from running to stopped state
    function onTimerStop()
    {
        m_TimerRunning = false;
    }

    //! Activity is ended
    function onTimerReset()
    {
    }




    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
    function onLayout(dc)
    {
        var obscurityFlags = DataField.getObscurityFlags();

        // Top left quadrant so we'll use the top left layout
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));

        // Top right quadrant so we'll use the top right layout
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        // Bottom left quadrant so we'll use the bottom left layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        // Bottom right quadrant so we'll use the bottom right layout
        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));

        // Use the generic, centered layout
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
        }

        return true;
    }

    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info)
    {
        //System.println("in Compute: timer=" + m_TimerRunning);
        // return if timer is not running.
        if(! m_TimerRunning)
        {
                return;
        }
        // See Activity.Info in the documentation for available information.
        if(info has :currentHeartRate)
        {
            if(info.currentHeartRate != null)
            {
                //System.println("in Compute Heart Rate: " + info.currentHeartRate);
                m_hearts[e_CUR] = info.currentHeartRate;
                m_hearts[e_AVG] = info.averageHeartRate;
                m_hearts[e_MAX] = info.maxHeartRate;
            }
            else
            {
                m_hearts = [0, 0, 0];
            }
        }
        if(info has :currentCadence)
        {
            if(info.currentCadence != null)
            {
                m_cadences[e_CUR] = info.currentCadence;
                m_cadences[e_AVG] = info.averageCadence;
                m_cadences[e_MAX] = info.maxCadence;
            }
            else
            {
                m_cadences = [0, 0, 0];
            }
        }
        if(info has :currentPower)
        {
            if(info.currentPower != null)
            {
                m_powerIntervalSet.update(info.currentPower);
            }
        }
        if(info has :elapsedTime)
        {
                m_elapsedTime = info.elapsedTime;
            }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc)
    {
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());
        var backgroundColor = getBackgroundColor();

        // Set the foreground color and value
        var heart = View.findDrawableById("heart");
        heart.setColor( (backgroundColor == Gfx.COLOR_BLACK) ? Gfx.COLOR_WHITE : Gfx.COLOR_BLACK );
        heart.setText(m_hearts[e_CUR].format("%d") + "/" + m_hearts[e_AVG].format("%d") + "/" + m_hearts[e_MAX].format("%d") + "h");
        var cadence = View.findDrawableById("cadence");
        cadence.setColor( (backgroundColor == Gfx.COLOR_BLACK) ? Gfx.COLOR_WHITE : Gfx.COLOR_BLACK );
        cadence.setText("c" + m_cadences[e_CUR].format("%d") + "/" + m_cadences[e_AVG].format("%d") + "/" + m_cadences[e_MAX].format("%d"));

        // set title locations
        var avgTitle = View.findDrawableById("avgTitle");
        avgTitle.locX = m_columnLocations[0];
        var durationTitle = View.findDrawableById("durationTitle");
        durationTitle.locX = m_columnLocations[1];
        var peakTitle = View.findDrawableById("peakTitle");
        peakTitle.locX = m_columnLocations[2];
        var targetTitle = View.findDrawableById("targetTitle");
        targetTitle.locX = m_columnLocations[3];

        // populate fields
        var avgFields = new [NUM_FIELDS];
        var durationFields = new [NUM_FIELDS];
        var peakFields = new [NUM_FIELDS];
        var targetFields = new [NUM_FIELDS];
        for( var indx = 0; indx < NUM_FIELDS; indx++ )
        {
            var fontColor = ( backgroundColor == Gfx.COLOR_BLACK) ? Gfx.COLOR_WHITE : Gfx.COLOR_BLACK;
            avgFields[indx]      = View.findDrawableById("avg" + indx);
            durationFields[indx] = View.findDrawableById("duration" + indx);
            peakFields[indx]     = View.findDrawableById("peak" + indx);
            targetFields[indx]   = View.findDrawableById("target" + indx);
            // get the peak power once
            var peak = m_powerIntervalSet.getPeak(indx);
            // set field to gray if the time has not expired
            if( m_elapsedTime/1000 < m_powerIntervalSet.getDuration(indx) )
            {
                //System.println("Elapsed: " + m_elapsedTime + ".  Duration(" +indx+ ") == " + m_powerIntervalSet.getDuration(indx));
                fontColor = Gfx.COLOR_LT_GRAY;
            }
            else
            {
                if(peak > m_powerIntervalSet.getGreenAt(indx))
                {
                    if(peak > m_powerIntervalSet.getTarget(indx))
                    {
                        fontColor = Gfx.COLOR_BLUE;
                    }
                    else
                    {
                        fontColor = Gfx.COLOR_GREEN;
                    }
                }
            }
            // set location
            avgFields[indx].locX = m_columnLocations[0];
            durationFields[indx].locX = m_columnLocations[1];
            peakFields[indx].locX = m_columnLocations[2];
            targetFields[indx].locX = m_columnLocations[3];
            // set colour
            avgFields[indx].setColor(fontColor);
            durationFields[indx].setColor(fontColor);
            peakFields[indx].setColor(fontColor);
            targetFields[indx].setColor(fontColor);
            // set values
            avgFields[indx].setText(m_powerIntervalSet.getAverage(indx).toString() + "W");
            durationFields[indx].setText(m_powerIntervalSet.getDurationText(indx));
            peakFields[indx].setText(peak.toString() + "W");
            targetFields[indx].setText(m_powerIntervalSet.getTarget(indx).toString() + "W");
        }

        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

    function getActivityMonitorInfo()
    {
        return Toybox.ActivityMonitor.getInfo();
    }

}
