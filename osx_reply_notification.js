ObjC.import("CoreGraphics");
ObjC.import('Cocoa');
// Notification only detects hover when moving from outside its borders
// over it, so first go to (0, 0).
var mouse = $.NSEvent.mouseLocation;
$.CGWarpMouseCursorPosition({x:0 , y:0});
var mainDisplayWidth = $.CGDisplayPixelsWide($.CGMainDisplayID());
var mainDisplayHeight = $.CGDisplayPixelsHigh($.CGMainDisplayID());
$.CGWarpMouseCursorPosition({x:mainDisplayWidth - 50, y:81});

Application("System Events")
    .processes["Notification Center"]
    .windows()[0]
    .buttons["Reply"]
    .click();
    
$.CGWarpMouseCursorPosition({x:mouse.x, y:mainDisplayHeight - mouse.y});

