// this class represents an interval.
// the user can set the time period and the target power.
// the interval stores the current state for that interval.

class PowerInterval
{
    protected var m_duration;  // seconds to count
    protected var m_fullTimeElapsed; // true once the full duration has elapsed once.
    protected var m_target;    // power target set by the user
    protected var m_greenAt;   // the power above which the indicator should turn green.
    protected var m_lastTotal;
    protected var m_average;   // current average for this interval
    protected var m_peak;      // peak average for the period
    protected var m_displayUnits;  // display 's' or 'm'
    protected var m_displayInterval;  // duration changed to minutes if needed

    function initialize( indx, greenAt )
    {
        var app = Application.getApp();
        m_fullTimeElapsed = false;
        // get Time settings
        try
        {
            m_duration = app.getProperty("Time" + indx).toNumber();
        }
        catch(ex)
        {
            System.println("Exception caught getting the Time" + indx + " property.  Error=" + ex.getErrorMessage());
            ex.printStackTrace();
            m_duration = 0;
        }
        // duration cannot be less than 2 seconds or greater than 2 hours
        if(m_duration < 2)
        {
            m_duration = 2;
        }
        if(m_duration > 7200)
        {
            m_duration = 7200;
        }

        // get Target settings
        try
        {
            m_target = app.getProperty("Target" + indx).toNumber();
        }
        catch(ex)
        {
            //System.println("Exception caught getting the Target" + indx + " property.  Error=" + ex.getErrorMessage());
            ex.printStackTrace();
            m_target = 0;
        }
        // target power cannot be less than 2W
        if(m_target < 2)
        {
            m_target = 2;
        }
        m_greenAt = Math.floor(greenAt * m_target);
        m_lastTotal = 0;
        m_average = 0;
        m_peak = 0;
        //
        setDisplayUnits();
        //System.println( "created PowerInterval of " + m_target + "W  for " + m_duration + "s.  green at " + m_greenAt.toNumber() );
    }

    function setDisplayUnits()
    {
        if(m_duration >= 60*60)
        {
            m_displayInterval = m_duration / 60 / 60;
            m_displayUnits = "h";
        }
        else if(m_duration >= 60)
        {
            m_displayInterval = m_duration / 60;
            m_displayUnits = "m";
        }
        else
        {
            m_displayInterval = m_duration;
            m_displayUnits = "s";
        }
    }

    function getTarget()
    {
        return m_target;
    }

    function getGreenAt()
    {
        return m_greenAt;
    }

    function getLastTotal()
    {
        return m_lastTotal;
    }

    function getDuration()
    {
        //System.println("Duration=" + m_duration);
        return m_duration;
    }

    function getFullTimeElapsed()
    {
        return m_fullTimeElapsed;
    }

    function getDurationText()
    {
        //System.println("DurationText=" + m_displayInterval.toString() + m_displayUnits);
        return m_displayInterval.toString() + m_displayUnits;
    }

    function getAverage()
    {
        return m_average;
    }

    function getPeak()
    {
        return m_peak;
    }

    function update(curHeadIndex, numbers)
    {
        try
        {
            var curTailIndex = curHeadIndex - m_duration;
            //System.println("curTailIndex(" + m_duration + ") ="+curTailIndex);
            // when the head has wrapped around and the time has elapsed, we need to wrap around
            if(m_fullTimeElapsed  && (curTailIndex < 0))
            {
                curTailIndex = numbers.size() + curTailIndex;
                //System.println("time (" + m_duration + ") elapsed, tail="+curTailIndex);
            }
            else
            {
                // if the time has elapsed, curTailIndex will be greater than -1.
                if((! m_fullTimeElapsed) && (curHeadIndex >= (m_duration)))
                {
                    m_fullTimeElapsed = true;
                    m_peak = m_average;
                    //System.println("m_fullTimeElapsed(" + m_duration + ")  is set for " + m_duration + "  average=" + m_average);
                }
            }
            m_lastTotal = m_lastTotal - ( curTailIndex >= 0 ? numbers[curTailIndex] : 0 ) + numbers[curHeadIndex];
            m_average = m_lastTotal / ( m_fullTimeElapsed ? m_duration : curHeadIndex + 1 );
            if((m_peak < m_average) || !m_fullTimeElapsed)
            {
                m_peak = m_average;
                //System.println("Peak set.  total(" + m_duration + ") ="+m_lastTotal+",  average="+m_average+",  peak="+m_peak + ",  timeElapsed=" + m_fullTimeElapsed);
            }
            //System.println("total(" + m_duration + ") ="+m_lastTotal+",  average="+m_average+",  peak="+m_peak + ",  timeElapsed=" + m_fullTimeElapsed);
        }
        catch(ex)
        {
            //System.println("Exception caught in PowerInterval::update(" + m_duration + ")  at index=" + curHeadIndex + ".  Exception=" + ex.getErrorMessage());
            ex.printStackTrace();
        }
    }

}
