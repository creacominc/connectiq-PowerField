// represents a Power Calculation
// stores the last N power numbers and computes the average
using Toybox.System;

class PowerCalc
{
    protected var numbers;
    protected var curHead;
    protected var curTail;
    protected var lastTotal;
    protected var mLogging;

    function initialize( numEntries, logging )
    {
        numbers = new [ numEntries ];
        curHead = -1;
        curTail = -1;
        lastTotal = 0;
        mLogging = logging;
        if(mLogging)
        {
            System.println("Created array of size: " + numEntries);
        }
    }

    function update( curPower )
    {
        // if the buffer is full, remove the head and subtract it from the total
        // the buffer is full if curHead == numbers.size - 1 or curHead == curTail - 1
        var curSize = numbers.size();
        if( (curHead == (curSize - 1)) || (curHead == (curTail - 1)) )
        {
            lastTotal = lastTotal - numbers[curTail] + curPower;
            numbers[curTail] = curPower;
            // rotate pointers
            curHead = curTail;
            curTail += 1;
            if(curTail >= curSize)
            {
                curTail = 0;
            }
        }
        else
        {
                // the list is not full, just add the new entry and update the total.
                if(curTail==-1)
                {
                    curTail = 0;
                }
                curHead += 1;
                numbers[curHead] = curPower;
                curSize = curHead - curTail + 1;
                lastTotal += curPower;
        }
        if(mLogging)
        {
                System.println("head=" + curHead + ",  tail=" + curTail + ", current=" + curPower + ", total=" + lastTotal + ", size=" + curSize);
        }
        return lastTotal/curSize;
    }
}
