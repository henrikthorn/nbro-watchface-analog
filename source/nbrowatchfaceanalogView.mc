using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;

class nbrowatchfaceanalogView extends Ui.WatchFace {

    // the x coordinate for the center
    var center_x;
    
    // the y coordinate for the center
    var center_y;

	//Use PI for calculations    
    var TWO_PI = Math.PI * 2;
    
    //We need to adjust the angle to get the correct positions for hands
    var ANGLE_ADJUST = Math.PI / 2.0;
    
    // the length of the minute hand
    var minute_radius;
    
    // the length of the hour hand
    var hour_radius;

    // the length of the hour hand
    var second_radius;
    
    var dcHandle;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
        
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;
        
        //Set length of clock hands
        second_radius = 7/8.0 * center_x;
        minute_radius = 3/4.0 * center_x;
        hour_radius = 5/9.0 * minute_radius;
        
        //Set DC handle to be able to work with DC in all functions
        dcHandle = dc;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    
    	dc.clear();	    	
    	
    	//Fill Screen in order to show seconds.. Logik.. Naaah...
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    	dc.fillCircle(center_x, center_y, 10 + dc.getWidth() / 2);
    	    	
        var clockTime = Sys.getClockTime();
        var hour = clockTime.hour;
        var minute = clockTime.min;
        var second = clockTime.sec;
    
        var hour_fraction = minute / 60.0;
        var minute_angle = hour_fraction * TWO_PI - ANGLE_ADJUST;
        var hour_angle = ((hour % 12) / 12.0) * TWO_PI - ANGLE_ADJUST;   
    	var seconds_angle = ( second / 60.0 ) * TWO_PI - ANGLE_ADJUST;   
    	        
		dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);

        // draw the minute hand
        dc.drawLine(center_x, center_y,
            (center_x + minute_radius * Math.cos(minute_angle)),
            (center_y + minute_radius * Math.sin(minute_angle)));
            
        // draw the hour hand
        dc.drawLine(center_x, center_y,
            (center_x + hour_radius * Math.cos(hour_angle)),
            (center_y + hour_radius * Math.sin(hour_angle))); 

		// draw the second hand
		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
		
        dc.drawLine(center_x, center_y,
            (center_x + second_radius * Math.cos(seconds_angle)),
            (center_y + second_radius * Math.sin(seconds_angle))); 
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
}
