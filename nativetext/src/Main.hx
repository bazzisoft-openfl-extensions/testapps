package;

import common.ITestPanelViewDelegate;
import common.TestPanelView;
import flash.display.Sprite;
import flash.events.Event;
import nativetext.event.NativeTextEvent;
import nativetext.NativeText;


class Main extends Sprite implements ITestPanelViewDelegate
{
	private static inline var BUTTON_ADD_TEXT_FIELD = "ADD NATIVE TEXT FIELD";

    private var m_testPanelView:TestPanelView = null;

	public function new()
    {
		super();

        NativeText.Initialize();

        stage.addEventListener(NativeTextEvent.TEXT_CHANGED, function(e) { trace(e); } );

        m_testPanelView = new TestPanelView(this, [BUTTON_ADD_TEXT_FIELD]);
        addChild(m_testPanelView);
  	}

    public function ProcessTestPanelButtonClick(button:String) : Void
    {
        switch (button)
        {
			case BUTTON_ADD_TEXT_FIELD:
				NativeText.AddTextField(100, 100);
				m_testPanelView.WriteLine("AddTextField - CALLED");
        }
    }
}