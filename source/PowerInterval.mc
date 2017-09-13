// this class represents an interval.
// the user can set the time period and the target power.
// the interval stores the current state for that interval.

class PowerInterval
{
    protected var m_duration;  // seconds to count
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
        var propertyName = "Time" + indx;
        m_duration = app.getProperty(propertyName);
        propertyName = "Target" + indx;
        m_target = app.getProperty(propertyName);
        m_greenAt = greenAt * m_target;
        m_lastTotal = 0;
        m_average = 0;
        m_peak = 0;
        if(m_duration > 60*60)
        {
                m_displayInterval = m_duration / 60.0 / 60.0;
                m_displayUnits = "h";
            }
            else if(m_duration > 60)
            {
                m_displayInterval = m_duration / 60.0;
                m_displayUnits = "m";
            }
            else
            {
                m_displayInterval = m_duration;
                m_displayUnits = "s";
            }
        //System.println("created PowerInterval of " + m_target + "W for " + m_duration + "s.  green at " + m_greenAt + "W");
    }

    function getTarget()
    {
        return m_target;
    }

    function getDuration()
    {
        return m_duration;
    }

    function getAverage()
    {
        return m_average;
    }

    function getPeak()
    {
        return m_peak;
    }

    function update(curHeadIndex, curTailIndex, numbers)
    {
        m_lastTotal = m_lastTotal - ( curTailIndex >= 0 ? numbers[curTailIndex] : 0 ) + numbers[curHeadIndex];
        m_average = m_lastTotal / m_duration;
        if( m_peak < m_average )
        {
            m_peak = m_average;
        }
    }

    function getText()
    {
        return m_average.format("%4.0f") + "W  " + m_displayInterval.format("%3.1f") + m_displayUnits + "   " + m_peak.format("%4.0f")  + "W   " + m_target.format("%3.0f") + "W";
    }


}