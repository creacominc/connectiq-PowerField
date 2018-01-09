using Toybox.Application as App;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class PowerFieldApp extends App.AppBase
{
    protected var m_usePeakColumn = false;
    protected var m_verboseLogging = true;

    function initialize()
    {
        try
        {
            AppBase.initialize();
            m_usePeakColumn = false;
            m_verboseLogging = getProperty("VerboseLogging");
        }
        catch(ex)
        {
            System.println("PowerFieldApp exception caught on initialize.  error=" + ex.getErrorMessage());
            ex.printStackTrace();
            throw ex;
        }
    }

    // onStart() is called on application start up
    function onStart(state)
    {
        try
        {
            var now = Gregorian.info(Time.now(), Time.FORMAT_LONG);
            var deviceSettings = System.getDeviceSettings();
            if(m_verboseLogging)
            {
                System.print("PowerField::onStart version=" + getProperty("AppVersion") + ", time=" + now.year + "/" + now.month + "/" + now.day +"@" + now.hour + ":" + now.min + ":" + now.sec );
                System.println(" monkeyVersion=" + Lang.format("$1$.$2$.$3$", deviceSettings.monkeyVersion) + ",  size=" + Lang.format("$1$x$2$", [deviceSettings.screenHeight, deviceSettings.screenWidth]));
            }
        }
        catch(ex)
        {
            System.println("PowerFieldApp exception caught in onStart(" + state + ").  error=" + ex.getErrorMessage());
            ex.printStackTrace();
            throw ex;
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state)
    {
        var now = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        if(m_verboseLogging)
        {
            System.println("PowerField::onStop version=" + getProperty("AppVersion") + ", time=" + now.year + "/" + now.month + "/" + now.day +"@" + now.hour + ":" + now.min + ":" + now.sec );
        }
    }

    //! Return the initial view of your application here
    function getInitialView()
    {
        try
        {
            return [ new PowerFieldView(), new PowerFieldDelegate() ];
        }
        catch(ex)
        {
            System.println("PowerFieldApp exception caught in getInitialView.  Please check the settings.  error=" + ex.getErrorMessage());
            ex.printStackTrace();
            throw ex;
        }
    }

    //! toggle the active column index
    function onTapHandler()
    {
        if(m_verboseLogging)
        {
            System.println("PowerField::onTapHandler status = " + m_usePeakColumn);
        }
        m_usePeakColumn = (! m_usePeakColumn);
    }

    //! get the peak column member
    function usePeakColumn()
    {
        return m_usePeakColumn;
    }
}