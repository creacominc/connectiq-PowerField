using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Graphics as Gfx;

class Background extends Ui.Drawable {

    hidden var mColor;

    function initialize()
    {
        try
        {
            var dictionary = {
                :identifier => "Background"
            };

            Drawable.initialize(dictionary);
        }
        catch(ex)
        {
            System.println("PowerField Background exception caught on initialize.  error=" + ex.getErrorMessage());
            ex.printStackTrace();
            throw ex;
        }
    }

    function setColor(color) {
        mColor = color;
    }

    function draw(dc) {
        dc.setColor(Gfx.COLOR_TRANSPARENT, mColor);
        dc.clear();
    }

}
