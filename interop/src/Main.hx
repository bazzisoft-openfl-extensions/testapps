package;

import common.ITestPanelViewDelegate;
import common.TestPanelView;
import flash.display.Sprite;
import flash.events.Event;
import interop.event.LaunchedFromURLEvent;
import interop.Interop;
import interop.utils.URLParser;


class Main extends Sprite implements ITestPanelViewDelegate
{
    private static inline var BUTTON_LAUNCH_GOOGLE = "LAUNCH GOOGLE";
    private static inline var BUTTON_LAUNCH_TEST_SITE = "LAUNCH TEST SITE";
    private static inline var BUTTON_SIMULATE_LAUNCHED_FROM_URL = "SIMULATE LAUNCHED FROM URL";

    private var m_testPanelView:TestPanelView = null;

    public function new()
    {
        super();

        m_testPanelView = new TestPanelView(this, [BUTTON_LAUNCH_GOOGLE, BUTTON_LAUNCH_TEST_SITE, BUTTON_SIMULATE_LAUNCHED_FROM_URL]);
        addChild(m_testPanelView);

        stage.addEventListener(LaunchedFromURLEvent.LAUNCHED_FROM_URL, function(e) { trace(e); });
        Interop.Initialize();
    }

    public function ProcessTestPanelButtonClick(button:String) : Void
    {
        switch (button)
        {
            case BUTTON_LAUNCH_GOOGLE:
                Interop.LaunchURL("http://www.google.com");

            case BUTTON_LAUNCH_TEST_SITE:
                Interop.LaunchURL("http://jsfiddle.net/2vjpB/embedded/result/");

            case BUTTON_SIMULATE_LAUNCHED_FROM_URL:
                Interop.SimulateLaunchedFromURL("interoptest://simulated/uid/?foo=bar");
        }
    }
}