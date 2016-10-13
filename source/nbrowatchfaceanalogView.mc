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
	
	//Add global dc handle to be able to use DC in all functions    
    var dcHandle;
    
    //Markers for clock
    var markers = [10, 20, 25, 35, 40, 50];
    var key_markers = [15, 30, 45];
    
    //Determine if we draw seconds.
    var seconds_marker = false;


    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
    
        setLayout(Rez.Layouts.WatchFace(dc));
        
        center_x = dc.getWidth() / 2;
        center_y = dc.getHeight() / 2;
        
        //Set length of clock hands
        second_radius = 30/40.0 * center_x;
        minute_radius = 25/40.0 * center_x;
        hour_radius = 20/40.0 * center_x;
        
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
    
    	//We start by clearing the display. Just to make sure.
    	dc.clear();	    	
    	
    	//Fill Screen in order to show seconds.. Logik.. Naaah...
    	dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    	dc.fillCircle(center_x, center_y, 10 + dc.getWidth() / 2);

		//Draw the NBRO Logo
        drawLogo();
        
        drawCharger();
    	    	
    	//Get time
        var clockTime = Sys.getClockTime();
        var hour = clockTime.hour;
        var minute = clockTime.min;
        var second = clockTime.sec;
    
    	//Calculate Angles to show hands in correct position
        var hour_fraction = minute / 60.0;
        var hour_angle = ((hour % 12) / 12.0) * TWO_PI - ANGLE_ADJUST;   
        var minute_angle = hour_fraction * TWO_PI - ANGLE_ADJUST;
    	var seconds_angle = ( second / 60.0 ) * TWO_PI - ANGLE_ADJUST;   
    	        
        // draw the minute hand
        dc.setPenWidth(1);
   		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(center_x, center_y,
            (center_x + minute_radius * Math.cos(minute_angle)),
            (center_y + minute_radius * Math.sin(minute_angle)));
            
        // draw the hour hand
        dc.setPenWidth(1);
   		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.drawLine(center_x, center_y,
            (center_x + hour_radius * Math.cos(hour_angle)),
            (center_y + hour_radius * Math.sin(hour_angle))); 

	
		// draw the seconds hand - if we are not in low power mode.
		if(seconds_marker){
			dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
			dc.setPenWidth(1);
	        dc.drawLine(center_x, center_y,
	            (center_x + second_radius * Math.cos(seconds_angle)),
	            (center_y + second_radius * Math.sin(seconds_angle))); 
       }
    
        //Draw markers for watch one at a time. Markers are every 5 minutes
        dc.setColor(Gfx.COLOR_DK_GRAY , Gfx.COLOR_TRANSPARENT);
        for( var i = 0; i < markers.size(); i++ ) {
        	var mark = markers[i];
        	var mark_angle = ( mark / 60.0 ) * TWO_PI - ANGLE_ADJUST;   
        		
    	    dc.drawLine((center_x + second_radius * Math.cos(mark_angle)), (center_y + second_radius * Math.sin(mark_angle)),
            	(center_x + (second_radius - 4)  * Math.cos(mark_angle)),
            (center_y + (second_radius - 4) * Math.sin(mark_angle)));
        	
		}
		
		//Draw key markers for watch one at a time. Key markers are every 15 minutes   
        dc.setColor(Gfx.COLOR_LT_GRAY , Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        for( var i = 0; i < key_markers.size(); i++ ) {
        	var mark = key_markers[i];
        	var mark_angle = ( mark / 60.0 ) * TWO_PI - ANGLE_ADJUST;   
        	
    	    dc.drawLine((center_x + second_radius * Math.cos(mark_angle)), (center_y + second_radius * Math.sin(mark_angle)),
            	(center_x + (second_radius - 8)  * Math.cos(mark_angle)),
            (center_y + (second_radius - 8) * Math.sin(mark_angle)));
        	
		}
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    	seconds_marker = true;
    	Ui.requestUpdate();
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    	seconds_marker = false;
		Ui.requestUpdate();
    }
    
    //Get the NBRO logo from ressources and print it to the display
    function drawLogo() {
        var x = dcHandle.getWidth() / 2;
        
    	var logo = Ui.loadResource(Rez.Drawables.NBROLogo);
    	var width = 120;
		dcHandle.drawBitmap(x - width/2, 2, logo);
    }
    
    function drawCharger() {
    
    	var stats = Sys.getSystemStats();

        var width = 20;
        var height = 12;
		var x  = dcHandle.getWidth() / 2 * 1.25;
		var y = dcHandle.getHeight() / 2 * 1.25;

        dcHandle.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
        dcHandle.fillRectangle(x,y,width,height);
        dcHandle.fillRectangle(x + width,y + height/2 - 2, 2, 4);
        dcHandle.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dcHandle.drawRectangle(x + 1,y + 1,width - 2, height - 2);
        dcHandle.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);

        var chargeWidth = ((width - 4).toFloat() * stats.battery).toLong() / 100;
        if(chargeWidth > (width -4))
        {
            chargeWidth = (width - 4).toLong();
        }

        dcHandle.fillRectangle(x + 2, y + 2, chargeWidth, height - 4);
    
        
    }
}
