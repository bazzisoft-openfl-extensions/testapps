package;

import common.ITestPanelViewDelegate;
import common.TestPanelView;
import flash.display.Sprite;
import flash.events.Event;
import mobiledisplay.event.MobileKeyboardPopupEvent;
import mobiledisplay.MobileDisplay;
import mobiledisplay.TouchKeyboardSimulator;


class Main extends Sprite implements ITestPanelViewDelegate
{
    private static inline var BUTTON_ENABLE_KEEP_SCREEN_ON = "ENABLE KEEP SCREEN ON";
    private static inline var BUTTON_DISABLE_KEEP_SCREEN_ON = "DISABLE KEEP SCREEN ON";

    private var m_testPanelView:TestPanelView = null;
    private var m_touchKeyboardSimulator:TouchKeyboardSimulator = null;

	public function new()
    {
		super();

        MobileDisplay.Initialize();

        stage.addEventListener(Event.RESIZE, HandleResize);
        stage.addEventListener(MobileKeyboardPopupEvent.KEYBOARD_ACTIVATED, function(e) { trace(e); } );
        stage.addEventListener(MobileKeyboardPopupEvent.KEYBOARD_DEACTIVATED, function(e) { trace(e); } );

        m_testPanelView = new TestPanelView(this, [BUTTON_ENABLE_KEEP_SCREEN_ON, BUTTON_DISABLE_KEEP_SCREEN_ON], true);
        addChild(m_testPanelView);

        HandleResize(null);
  	}

    public function ProcessTestPanelButtonClick(button:String) : Void
    {
        switch (button)
        {
            case BUTTON_ENABLE_KEEP_SCREEN_ON:
                MobileDisplay.KeepScreenOn(true);
                m_testPanelView.WriteLine("KeepScreenOn - ENABLED");

            case BUTTON_DISABLE_KEEP_SCREEN_ON:
                MobileDisplay.KeepScreenOn(false);
                m_testPanelView.WriteLine("KeepScreenOn - DISABLED");
        }
    }

    private function HandleResize(e:Event) : Void
    {
        #if !mobile
        if (m_touchKeyboardSimulator != null)
        {
            removeChild(m_touchKeyboardSimulator);
        }

        m_touchKeyboardSimulator = new TouchKeyboardSimulator(stage.stageWidth, stage.stageHeight);
        addChild(m_touchKeyboardSimulator);
        #end
    }
}