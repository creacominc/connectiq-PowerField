// this class represents the collection of power intervals


class PowerIntervalSet
{
    protected var m_numbers = [];
    protected var m_powerIntervalSet = [];
    protected var m_insertHead = -1;
    protected var m_insertTail = -1;

    function initialize(numberOfFields)
    {
        var largestIntervalInSeconds = 0;
        var greenAt = 0.80;  // turn green at 80% of the target... @TODO move this to a resource.
        for( var indx = 0; indx < numberOfFields; indx++ )
        {
            // create and add a PowerInterval to the collection - note the largest interval
            m_powerIntervalSet.add(new PowerInterval(indx, greenAt));
            var duration = m_powerIntervalSet[ m_powerIntervalSet.size() - 1 ].getDuration();
            //System.println("size: " + duration);
            if(duration > largestIntervalInSeconds)
            {
                largestIntervalInSeconds = duration;
            }
        }
        //System.println("creating number array of size: " + largestIntervalInSeconds);
        m_numbers = new [ largestIntervalInSeconds ];
    }

    function update(currentPower)
    {
        // if the buffer is full, remove the head and subtract it from the total
        // the buffer is full if m_insertHead == m_numbers.size - 1 or m_insertHead == m_insertTail - 1
        var curSize = m_numbers.size();
        if( (m_insertHead == (curSize - 1)) || (m_insertHead == (m_insertTail - 1)) )
        {
            numbers[m_insertTail] = currentPower;
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
            // the list is not full, just add the new entry and update the total.
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

    function getText(indx)
    {
        return m_powerIntervalSet[indx].getText();
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
