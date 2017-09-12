// this class represents an interval.
// the user can set the time period and the target power.
// the interval stores the current state for that interval.

class PowerInterval
{
    protected var m_duration;  // seconds to count
    protected var m_target;    // power target set by the user
    protected var m_greenAt;   // the power above which the indicator should turn green.
    protected var m_average;   // current average for this interval
    protected var m_peak;      // peak average for the period

    function initialize( targetTime, targetPower, greenAt )
    {
	 m_duration = targetTime;
	 m_target = targetPower;
	 m_greenAt = greenAt;
     	 m_average = 0;
	 m_peak = 0;
    }


}
