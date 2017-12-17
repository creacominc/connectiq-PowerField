using Toybox.WatchUi;

class PowerFieldDelegate extends WatchUi.InputDelegate
{

    function initialize()
    {
        try
        {
            InputDelegate.initialize();
        }
        catch(ex)
        {
            System.println("PowerFieldDelegate exception caught on initialize.  error=" + ex.getErrorMessage());
            ex.printStackTrace();
            throw ex;
        }
    }

    function onTap( evt )
    {
        var app = Application.getApp();
        app.onTapHandler();
    }

}
