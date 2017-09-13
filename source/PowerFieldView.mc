using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;

class PowerFieldView extends Ui.DataField
{
    protected var mTimerRunning = false;

    protected var mHeart;

    protected var m_powerIntervalSet;

    function initialize()
    {
        DataField.initialize();
        mHeart = 0.0f;
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
                var offset = -85;
                var space = 0;
                var delta = 20;
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY + offset + space;
            space += delta;
            var heartView = View.findDrawableById("heart");
            heartView.locY = heartView.locY + offset + space;
            space += delta;
            var powerView3s = View.findDrawableById("power3s");
            powerView3s.locY = powerView3s.locY + offset + space;
            space += delta;
            var powerView30s = View.findDrawableById("power30s");
            powerView30s.locY = powerView30s.locY + offset + space;
            space += delta;
            var powerView120s = View.findDrawableById("power120s");
            powerView120s.locY = powerView120s.locY + offset + space;
            space += delta;
            var powerView300s = View.findDrawableById("power300s");
            powerView300s.locY = powerView300s.locY + offset + space;
            space += delta;
            var powerView1200s = View.findDrawableById("power1200s");
            powerView1200s.locY = powerView1200s.locY + offset + space;
            space += delta;
            var powerView3600s = View.findDrawableById("power3600s");
            powerView3600s.locY = powerView3600s.locY + offset + space;
            space += delta;
            var powerView7200s = View.findDrawableById("power7200s");
            powerView7200s.locY = powerView7200s.locY + offset + space;
            space += delta;
        }

        View.findDrawableById("label").setText(Rez.Strings.label);
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
                mHeart = info.currentHeartRate;
            }
            else
            {
                mHeart = 0.0f;
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
        heart.setText(mHeart.format("%.0f") + " bpm");

        // populate power data
        var power3s = View.findDrawableById("power3s");
        var power30s = View.findDrawableById("power30s");
        var power120s = View.findDrawableById("power120s");
        var power300s = View.findDrawableById("power300s");
        var power1200s = View.findDrawableById("power1200s");
        var power3600s = View.findDrawableById("power3600s");
        var power7200s = View.findDrawableById("power7200s");
        if (getBackgroundColor() == Gfx.COLOR_BLACK) {
            power3s.setColor(Gfx.COLOR_WHITE);
            power30s.setColor(Gfx.COLOR_WHITE);
            power120s.setColor(Gfx.COLOR_WHITE);
            power300s.setColor(Gfx.COLOR_WHITE);
            power1200s.setColor(Gfx.COLOR_WHITE);
            power3600s.setColor(Gfx.COLOR_WHITE);
            power7200s.setColor(Gfx.COLOR_WHITE);
        } else {
            power3s.setColor(Gfx.COLOR_BLACK);
            power30s.setColor(Gfx.COLOR_BLACK);
            power120s.setColor(Gfx.COLOR_BLACK);
            power300s.setColor(Gfx.COLOR_BLACK);
            power1200s.setColor(Gfx.COLOR_BLACK);
            power3600s.setColor(Gfx.COLOR_BLACK);
            power7200s.setColor(Gfx.COLOR_BLACK);
        }

        power3s.setText(m_powerIntervalSet.getText(0));
        power30s.setText(m_powerIntervalSet.getText(1));
        power120s.setText(m_powerIntervalSet.getText(2));
        power300s.setText(m_powerIntervalSet.getText(3));
        power1200s.setText(m_powerIntervalSet.getText(4));
        power3600s.setText(m_powerIntervalSet.getText(5));
        power7200s.setText(m_powerIntervalSet.getText(6));


        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

    function getActivityMonitorInfo()
    {
        return Toybox.ActivityMonitor.getInfo();
    }

}
