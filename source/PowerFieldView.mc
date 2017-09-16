using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;

class PowerFieldView extends Ui.DataField
{
    protected var mTimerRunning = false;

    protected var m_heart;

    protected var m_powerIntervalSet;

    function initialize()
    {
        DataField.initialize();
        m_heart = 0.0f;
        m_powerIntervalSet = new PowerIntervalSet(7);
    }


    //! Timer transitions from stopped to running state
    function onTimerStart()
    {
        if (!mTimerRunning)
        {
            //var activityMonitorInfo = getActivityMonitorInfo();
            mTimerRunning = true;
        }
    }

    //! Timer transitions from running to stopped state
    function onTimerStop()
    {
        mTimerRunning = false;
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
        //System.println("in Compute: timer=" + mTimerRunning);
        // return if timer is not running.
        if(! mTimerRunning)
        {
                return;
        }
        // See Activity.Info in the documentation for available information.
        if(info has :currentHeartRate)
        {
            if(info.currentHeartRate != null)
            {
                //System.println("in Compute Heart Rate: " + info.currentHeartRate);
                m_heart = info.currentHeartRate;
            }
            else
            {
                m_heart = 0.0f;
            }
        }
        if(info has :currentPower)
        {
            if(info.currentPower != null)
            {
                m_powerIntervalSet.update(info.currentPower);
            }
        }
    }

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc)
    {
        // Set the background color
        View.findDrawableById("Background").setColor(getBackgroundColor());

        // Set the foreground color and value
        var heart = View.findDrawableById("heart");
        if (getBackgroundColor() == Gfx.COLOR_BLACK) {
            heart.setColor(Gfx.COLOR_WHITE);
        } else {
            heart.setColor(Gfx.COLOR_BLACK);
        }
        heart.setText(m_heart.format("%.0f") + " bpm");

        var backgroundColor = getBackgroundColor();

        // populate fields
        var avgFields = new [7];
        var durationFields = new [7];
        var peakFields = new [7];
        var targetFields = new [7];
        for( var indx = 0; indx < 7; indx++ )
        {
                avgFields[indx]      = View.findDrawableById("avg" + indx);
                durationFields[indx] = View.findDrawableById("duration" + indx);
                peakFields[indx]     = View.findDrawableById("peak" + indx);
                targetFields[indx]   = View.findDrawableById("target" + indx);
                if( backgroundColor == Gfx.COLOR_BLACK)
                {
                        avgFields[indx].setColor(Gfx.COLOR_WHITE);
                        durationFields[indx].setColor(Gfx.COLOR_WHITE);
                        peakFields[indx].setColor(Gfx.COLOR_WHITE);
                        targetFields[indx].setColor(Gfx.COLOR_WHITE);
                }
                else
                {
                        avgFields[indx].setColor(Gfx.COLOR_BLACK);
                        durationFields[indx].setColor(Gfx.COLOR_BLACK);
                        peakFields[indx].setColor(Gfx.COLOR_BLACK);
                        targetFields[indx].setColor(Gfx.COLOR_BLACK);
                }
                avgFields[indx].setText(m_powerIntervalSet.getAverage(indx).toString() + "W");
                durationFields[indx].setText(m_powerIntervalSet.getDurationText(indx));
                peakFields[indx].setText(m_powerIntervalSet.getPeak(indx).toString() + "W");
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
