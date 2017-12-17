// this class represents the collection of power intervals


class PowerIntervalSet
{
    protected var m_numbers = [];
    protected var m_powerIntervalSet = [];
    protected var m_insertHead = -1;
    protected var m_insertTail = -1;
    protected var m_verboseLogging = true;

    function initialize(numberOfFields)
    {
        try
        {
            var largestIntervalInSeconds = 60;  // minimum storage will be 60 seconds
            var lastDuration = 0;
            var greenAt = 0.80;  // turn green at 80% of the target... @TODO move this to a resource.
            var app = Application.getApp();
            m_verboseLogging = app.getProperty("VerboseLogging");
            for( var indx = 0; indx < numberOfFields; indx++ )
            {
                var duration = 0;
                try
                {
                    // create and add a PowerInterval to the collection - note the largest interval
                    duration = app.getProperty("Time" + indx).toNumber();
                }
                catch(ex)
                {
                    System.println("PowerField/Exception caught getting the Time" + indx + " property.  Error=" + ex.getErrorMessage());
                    ex.printStackTrace();
                    duration = 0;
                }
                // duration cannot be less than the last duration plus 2 seconds or greater than 2 hours
                    if((duration < lastDuration + 2) || (duration > 7200))
                {
                    duration = lastDuration + 2;
                }
                lastDuration = duration;
                m_powerIntervalSet.add(new PowerInterval(indx, duration, greenAt));
                if(m_verboseLogging)
                {
                        System.println("size: " + duration);
                    }
                if(duration > largestIntervalInSeconds)
                {
                    largestIntervalInSeconds = duration;
                }
            }
            if(m_verboseLogging)
            {
                System.println("creating number array of size: " + largestIntervalInSeconds);
            }
            m_numbers = new [ largestIntervalInSeconds + 1 ];
        }
        catch(ex)
        {
            System.println("PowerIntervalSet exception caught on initialize.  error=" + ex.getErrorMessage());
            ex.printStackTrace();
            throw ex;
        }
    }

    function update(currentPower)
    {
        // if the buffer is full, remove the head and subtract it from the total
        // the buffer is full if m_insertHead == m_numbers.size - 1 or m_insertHead == m_insertTail - 1
        var curSize = m_numbers.size();
        if( (m_insertHead == (curSize - 1)) || (m_insertHead == (m_insertTail - 1)) )
        {
            m_numbers[m_insertTail] = currentPower;
            // rotate pointers
            m_insertHead = m_insertTail;
            m_insertTail += 1;
            if(m_insertTail >= curSize)
            {
                m_insertTail = 0;
            }
        }
        else
        {
            // the list is not full, just add the new entry.
            if(m_insertTail==-1)
            {
                m_insertTail = 0;
            }
            m_insertHead++;
            m_numbers[m_insertHead] = currentPower;
        }
        // update all the Intervals
        var numberOfSets = m_powerIntervalSet.size();
        for(var indx = 0; indx < numberOfSets; indx++)
        {
            m_powerIntervalSet[indx].update(m_insertHead, m_numbers);
        }
    }

    function getPeak(indx)
    {
        return m_powerIntervalSet[indx].getPeak();
    }

    function getAverage(indx)
    {
        return m_powerIntervalSet[indx].getAverage();
    }

    function getDuration(indx)
    {
        return m_powerIntervalSet[indx].getDuration();
    }

    function getDurationText(indx)
    {
        return m_powerIntervalSet[indx].getDurationText();
    }

    function getTarget(indx)
    {
        return m_powerIntervalSet[indx].getTarget();
    }

    function getGreenAt(indx)
    {
        return m_powerIntervalSet[indx].getGreenAt();
    }

}
