using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System;

class PowerFieldView extends Ui.DataField
{
    protected var mTimerRunning = false;

    // collection of 7 PowerIntervals
    protected var m_PowerIntervals = [
    	      	  		     new PowerInterval( 3, 800, 0.8 * 800 ),
    	      	  		     new PowerInterval( 30, 600, 0.8 * 600 ),
    	      	  		   ];

    protected var mHeart;
    protected var mPower3s;
    protected var mPower30s;
    protected var mPower120s;
    protected var mPower300s;
    protected var mPower1200s;
    protected var mPower3600s;
    protected var mPower7200s;
    protected var powerCalc3s;
    protected var powerCalc30s;
    protected var powerCalc120s;
    protected var powerCalc300s;
    protected var powerCalc1200s;
    protected var powerCalc3600s;
    protected var powerCalc7200s;
    protected var mPeak3s;
    protected var mPeak30s;
    protected var mPeak120s;
    protected var mPeak300s;
    protected var mPeak1200s;
    protected var mPeak3600s;
    protected var mPeak7200s;

    function initialize()
    {
        DataField.initialize();
        mHeart = 0.0f;
        mPower3s = 0.0f;
        mPower30s = 0.0f;
        mPower120s = 0.0f;
        mPower300s = 0.0f;
        mPower1200s = 0.0f;
        mPower3600s = 0.0f;
        mPower7200s = 0.0f;
        powerCalc3s = new PowerCalc(3, false);
        powerCalc30s = new PowerCalc(30, false);
        powerCalc120s = new PowerCalc(120, false);
        powerCalc300s = new PowerCalc(300, false);
        powerCalc1200s = new PowerCalc(1200, false);
        powerCalc3600s = new PowerCalc(3600, false);
        powerCalc7200s = new PowerCalc(7200, false);
        mPeak3s = 0.0f;
        mPeak30s = 0.0f;
        mPeak120s = 0.0f;
        mPeak300s = 0.0f;
        mPeak1200s = 0.0f;
        mPeak3600s = 0.0f;
        mPeak7200s = 0.0f;
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
                //System.println("in Compute Power: " + info.currentPower);
                mPower3s = powerCalc3s.update(info.currentPower);
                mPower30s = powerCalc30s.update(info.currentPower);
                mPower120s = powerCalc120s.update(info.currentPower);
                mPower300s = powerCalc300s.update(info.currentPower);
                mPower1200s = powerCalc1200s.update(info.currentPower);
                mPower3600s = powerCalc3600s.update(info.currentPower);
                mPower7200s = powerCalc7200s.update(info.currentPower);
            }
            else
            {
                mPower3s = 0.0f;
                mPower30s = 0.0f;
                mPower120s = 0.0f;
                mPower300s = 0.0f;
                mPower1200s = 0.0f;
                mPower3600s = 0.0f;
                mPower7200s = 0.0f;
            }
            if(mPeak3s < mPower3s) {mPeak3s = mPower3s;}
            if(mPeak30s < mPower30s) {mPeak30s = mPower30s;}
            if(mPeak120s < mPower120s) {mPeak120s = mPower120s;}
            if(mPeak300s < mPower300s) {mPeak300s = mPower300s;}
            if(mPeak1200s < mPower1200s) {mPeak1200s = mPower1200s;}
            if(mPeak3600s < mPower3600s) {mPeak3600s = mPower3600s;}
            if(mPeak7200s < mPower7200s) {mPeak7200s = mPower7200s;}
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
        var mPerCent3s     = mPeak3s * 100.0 / 956.0;
        var mPerCent30s    = mPeak30s * 100.0 / 601.0;
        var mPerCent120s   = mPeak120s * 100.0 / 362.0;
        var mPerCent300s   = mPeak300s * 100.0 / 303.0;
        var mPerCent1200s  = mPeak1200s * 100.0 / 238.0;
        var mPerCent3600s  = mPeak3600s * 100.0 / 218.0;
        var mPerCent7200s  = mPeak7200s * 100.0 / 199.00;
        power3s.setText(mPower3s.format("%4.0f") + "  3s   " + mPeak3s.format("%4.0f")  + "   " + mPerCent3s.format("%3.0f") + "%");
        power30s.setText(mPower30s.format("%4.0f") + "  30s  " + mPeak30s.format("%4.0f")  + "   " + mPerCent30s.format("%3.0f") + "%");
        power120s.setText(mPower120s.format("%4.0f") + "  2m   " + mPeak120s.format("%4.0f")  + "   " + mPerCent120s.format("%3.0f") + "%");
        power300s.setText(mPower300s.format("%4.0f") + "  5m   " + mPeak300s.format("%4.0f")  + "   " + mPerCent300s.format("%3.0f") + "%");
        power1200s.setText(mPower1200s.format("%4.0f") + "  20m  " + mPeak1200s.format("%4.0f")  + "   " + mPerCent1200s.format("%3.0f") + "%");
        power3600s.setText(mPower3600s.format("%4.0f") + "  1h   " + mPeak3600s.format("%4.0f")  + "   " + mPerCent3600s.format("%3.0f") + "%");
        power7200s.setText(mPower7200s.format("%4.0f") + "  2h   " + mPeak7200s.format("%4.0f")  + "   " + mPerCent7200s.format("%3.0f") + "%");


        // Call parent's onUpdate(dc) to redraw the layout
        View.onUpdate(dc);
    }

    function getActivityMonitorInfo()
    {
        return Toybox.ActivityMonitor.getInfo();
    }

}
