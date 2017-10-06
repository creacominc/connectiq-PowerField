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
        m_duration = app.getProperty("Time" + indx);
        // duration cannot be less than 2 seconds or greater than 2 hours
        if(m_duration < 2)
        {
            m_duration = 2;
        }
        if(m_duration > 7200)
        {
            m_duration = 7200;
        }
        m_fullTimeElapsed = false;
        m_target = app.getProperty("Target" + indx);
        // target power cannot be less than 2W
        if(m_target < 2)
        {
            m_target = 2;
        }
        m_greenAt = greenAt * m_target;
        m_lastTotal = 0;
        m_average = 0;
        m_peak = 0;
        setDisplayUnits();
        //System.println("created PowerInterval of " + m_target + "W for " + m_duration + "s.  green at " + m_greenAt + "W");
    }

    function setDisplayUnits()
    {
        if(m_duration > 60*60)
        {
            m_displayInterval = m_duration / 60 / 60;
            m_displayUnits = "h";
        }
        else if(m_duration > 60)
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

    function getDuration()
    {
        return m_duration;
    }

    function getDurationText()
    {
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
        var curTailIndex = curHeadIndex - m_duration;
        // if the time has elapsed, curTailIndex will be greater than -1.
        if(curTailIndex >= 0)
        {
            m_fullTimeElapsed = true;
        }
        else
        {
            // when the head has wrapped around and the time has elapsed, we need to wrap around
            if(m_fullTimeElapsed)
            {
                curTailIndex = numbers.size() + curTailIndex;
            }
        }
        m_lastTotal = m_lastTotal - ( curTailIndex >= 0 ? numbers[curTailIndex] : 0 ) + numbers[curHeadIndex];
        m_average = m_lastTotal / ( m_fullTimeElapsed ? m_duration : curHeadIndex + 1 );
        if( m_peak < m_average )
        {
            m_peak = m_average;
        }
    }

    function getText()
    {
        //return m_average.format("%4.0f") + "W  " + m_displayInterval.format("%3.1f") + m_displayUnits + "   " + m_peak.format("%4.0f")  + "W   " + m_target.format("%3.0f") + "W";
        return ""
             + m_displayInterval.format("%5.1f") + m_displayUnits + " "
             + m_target.format("%3.0f") + "W "
                     + m_average.format("%5.0f") + "W "
             + m_peak.format("%5.0f")  + "W "
           ;
    }
}
