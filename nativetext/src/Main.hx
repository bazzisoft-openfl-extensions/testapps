package;

import common.ITestPanelViewDelegate;
import common.TestPanelView;
import flash.display.Sprite;
import flash.events.Event;
import nativetext.event.NativeTextEvent;
import nativetext.NativeText;
import nativetext.NativeTextField;


class Main extends Sprite implements ITestPanelViewDelegate
{
	private static inline var BUTTON_ADD_TEXT_FIELD = "ADD NATIVE TEXT FIELD";
	private static inline var BUTTON_REMOVE_TEXT_FIELD = "REMOVE NATIVE TEXT FIELD";

    private var m_testPanelView:TestPanelView = null;
	private var m_textFieldStack = new Array<NativeTextField>();
	private var m_initial_y = 100;
	

	public function new()
    {
		super();

        NativeText.Initialize();

        stage.addEventListener(NativeTextEvent.TEXT_CHANGED, function(e) { trace("Stage Event: " + e); } );

        m_testPanelView = new TestPanelView(this, [BUTTON_ADD_TEXT_FIELD, BUTTON_REMOVE_TEXT_FIELD]);
        addChild(m_testPanelView);
  	}

    public function ProcessTestPanelButtonClick(button:String) : Void
    {
        switch (button)
        {
			case BUTTON_ADD_TEXT_FIELD:
			{
				var tf = new NativeTextField();
				m_textFieldStack.push(tf);
				tf.addEventListener(NativeTextEvent.TEXT_CHANGED, function(e) { trace("Textfield #" + tf.eventDispatcherId + ": " + e); } );
				m_testPanelView.WriteLine("Created text field #" + tf.eventDispatcherId + ".");
			}
				
			case BUTTON_REMOVE_TEXT_FIELD:
			{
				if (m_textFieldStack.length > 0)
				{
					var tf = m_textFieldStack.pop();
					m_testPanelView.WriteLine("Removing last text field (#" + tf.eventDispatcherId + ").");
					tf.Destroy();
				}
				else
				{
					m_testPanelView.WriteLine("No text fields exist.");
				}
			}
        }
    }
}