using Toybox.Application as App;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;

class PowerFieldApp extends App.AppBase
{
    protected var m_usePeakColumn = false;

    function initialize()
    {
        AppBase.initialize();
        m_usePeakColumn = false;
    }

    // onStart() is called on application start up
    function onStart(state)
    {
        var now = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var deviceSettings = System.getDeviceSettings();
        System.print("PowerField::onStart version=" + getProperty("AppVersion") + ", time=" + now.year + "/" + now.month + "/" + now.day +"@" + now.hour + ":" + now.min + ":" + now.sec );
        System.println(" monkeyVersion=" + Lang.format("$1$.$2$.$3$", deviceSettings.monkeyVersion) + ",  size=" + Lang.format("$1$x$2$", [deviceSettings.screenHeight, deviceSettings.screenWidth]));
    }

    // onStop() is called when your application is exiting
    function onStop(state)
    {
        var now = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        System.println("PowerField::onStop version=" + getProperty("AppVersion") + ", time=" + now.year + "/" + now.month + "/" + now.day +"@" + now.hour + ":" + now.min + ":" + now.sec );
    }

    //! Return the initial view of your application here
    function getInitialView()
    {
        return [ new PowerFieldView(), new PowerFieldDelegate() ];
    }

    //! toggle the active column index
    function onTapHandler()
    {
        //System.println("PowerField::onTapHandler status = " + m_usePeakColumn);
        m_usePeakColumn = (! m_usePeakColumn);
    }

    //! get the peak column member
    function usePeakColumn()
    {
        return m_usePeakColumn;
    }
}