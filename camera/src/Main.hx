package;

import camera.Camera;
import camera.event.CameraEvent;
import common.ITestPanelViewDelegate;
import common.TestPanelView;
import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.events.Event;
import haxe.io.Bytes;
import haxe.Timer;
import openfl.Assets;


class Main extends Sprite implements ITestPanelViewDelegate
{
    private static inline var BUTTON_CAPTURE_PHOTO = "CAPTURE PHOTO";
    private static inline var BUTTON_SET_FAKE_PHOTO_RESULT = "SET FAKE PHOTO RESULT";
    private static inline var BUTTON_SIMULATE_PHOTO_CAPTURED = "SIMULATE PHOTO CAPTURED";
    private static inline var BUTTON_SIMULATE_PHOTO_CANCELLED = "SIMULATE PHOTO CANCELLED";

    private var m_testPanelView:TestPanelView = null;

    public function new()
    {
        super();

        m_testPanelView = new TestPanelView(this, [BUTTON_CAPTURE_PHOTO, BUTTON_SET_FAKE_PHOTO_RESULT, BUTTON_SIMULATE_PHOTO_CAPTURED, BUTTON_SIMULATE_PHOTO_CANCELLED]);
        addChild(m_testPanelView);

        Camera.Initialize();
        stage.addEventListener(CameraEvent.PHOTO_CAPTURED, HandlePhotoCaptured);
        stage.addEventListener(CameraEvent.PHOTO_CANCELLED, function(e) { trace(e); });
    }

    public function ProcessTestPanelButtonClick(button:String) : Void
    {
        switch (button)
        {
            case BUTTON_CAPTURE_PHOTO:
                var ret = Camera.CapturePhoto(1024);
                trace("Camera.CapturePhoto(): " + Std.string(ret));

            case BUTTON_SET_FAKE_PHOTO_RESULT:
                Camera.SetFakePhotoResult(Assets.getBitmapData("assets/img/nature.jpg"));
                trace("Camera.SetFakePhotoResult(): Set nature image.");

            case BUTTON_SIMULATE_PHOTO_CAPTURED:
                Camera.SimulatePhotoCaptured(Assets.getBitmapData("assets/img/nature.jpg"));

            case BUTTON_SIMULATE_PHOTO_CANCELLED:
                Camera.SimulatePhotoCancelled();
        }
    }
    
    public function HandlePhotoCaptured(e:CameraEvent) : Void
    {
        trace(e);
        
        var imageData:Bytes = e.GetImageData();
        
        var bitmapData = e.GetBitmapData();
        var bitmap = new Bitmap(bitmapData, PixelSnapping.AUTO, true);
        ResizeToHalfScreen(bitmap);
        
        var spr:Sprite = new Sprite();
        spr.graphics.beginFill(0x555555);
        spr.graphics.drawRect(0, 0, bitmap.width + 20, bitmap.height + 20);
        spr.graphics.endFill();
        spr.addChild(bitmap);
        
        
        CenterOnParent(bitmap, spr);
        CenterOnParent(spr, this);
        addChild(spr);
        
        Timer.delay(function() { removeChild(spr); }, 5000);
    }    
    
    public function ResizeToHalfScreen(displayObject:DisplayObject)
    {
        var w = displayObject.width;
        var h = displayObject.height;
        var aspect = w / h;
        var stageW = stage.stageWidth;
        var stageH = stage.stageHeight;
        
        if (w >= h && w > stageW / 2)
        {
            w = stageW / 2;
            h = w / aspect;            
        }
        else if (h > w && h > stageH / 2)
        {
            h = stageH / 2;
            w = h * aspect;
        }
        
        displayObject.width = w;
        displayObject.height = h;
    }
    
    public function CenterOnParent(displayObject:DisplayObject, parent:DisplayObject) : Void
    {
        displayObject.x = Math.floor((parent.width - displayObject.width) / 2);
        displayObject.y = Math.floor((parent.height - displayObject.height) / 2);
    }        
}