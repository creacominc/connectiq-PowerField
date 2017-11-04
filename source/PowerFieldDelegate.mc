using Toybox.WatchUi;

class PowerFieldDelegate extends WatchUi.InputDelegate
{

    function initialize()
    {
        InputDelegate.initialize();
    }

    function onTap( evt )
    {
        var app = Application.getApp();
        app.onTapHandler();
    }

}
