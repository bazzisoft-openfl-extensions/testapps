package;

import common.ITestPanelViewDelegate;
import common.TestPanelView;
import flash.display.Sprite;
import flash.events.Event;
import haxe.Utf8;
import nativetext.event.NativeTextEvent;
import nativetext.NativeText;
import nativetext.NativeTextField;


class Main extends Sprite implements ITestPanelViewDelegate
{
	private static inline var BUTTON_ADD_TEXT_FIELD = "ADD NATIVE TEXT FIELD";
	private static inline var BUTTON_REMOVE_TEXT_FIELD = "REMOVE NATIVE TEXT FIELD";
	private static inline var BUTTON_GET_TEXT = "GET TEXT";
	private static inline var BUTTON_SET_TEXT = "SET RANDOM TEXT";

    private var m_testPanelView:TestPanelView = null;
	private var m_textFieldStack = new Array<NativeTextField>();
	private var m_initial_y = 100;
	

	public function new()
    {
		super();

        NativeText.Initialize();

        stage.addEventListener(NativeTextEvent.TEXT_CHANGED, function(e) { trace("Stage Event: " + e); } );

        m_testPanelView = new TestPanelView(this, [BUTTON_ADD_TEXT_FIELD, BUTTON_REMOVE_TEXT_FIELD, BUTTON_GET_TEXT, BUTTON_SET_TEXT]);
        addChild(m_testPanelView);
  	}

	public function StringToHex(s:String) : String
	{
		var output = "";
		
		for (i in 0...s.length)
		{
			output += StringTools.hex(s.charCodeAt(i), 2);
			output += " ";
		}
		
		return StringTools.trim(output);
	}
	
    public function ProcessTestPanelButtonClick(button:String) : Void
    {
        switch (button)
        {
			case BUTTON_ADD_TEXT_FIELD:
			{
				var tf = new NativeTextField();
				m_textFieldStack.push(tf);
				tf.addEventListener(NativeTextEvent.TEXT_CHANGED, function(e) { m_testPanelView.WriteLine("Textfield #" + tf.eventDispatcherId + ": " + e); } );
				tf.addEventListener(NativeTextEvent.ACTION_KEY_PRESSED, function(e) { m_testPanelView.WriteLine("Textfield #" + tf.eventDispatcherId + ": " + e); } );
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
			
			case BUTTON_GET_TEXT:
			{
				if (m_textFieldStack.length > 0)
				{
					var tf = m_textFieldStack[m_textFieldStack.length - 1];
					var text = tf.GetText();
					m_testPanelView.WriteLine("Last text field (#" + tf.eventDispatcherId + ") value = '" + text + "'.");					
					trace(StringToHex(text));
				}
				else
				{
					m_testPanelView.WriteLine("No text fields exist.");
				}
			}
				
			case BUTTON_SET_TEXT:
			{
				if (m_textFieldStack.length > 0)
				{
					var text = "שלום לך";
					if (Std.random(2) == 1)
					{
						text = Std.string(Std.random(99999) + 11111);
					}
					
					var tf = m_textFieldStack[m_textFieldStack.length - 1];
					m_testPanelView.WriteLine("Setting last text field (#" + tf.eventDispatcherId + ") to '" + text + "'.");
					tf.SetText(text);
				}
				else
				{
					m_testPanelView.WriteLine("No text fields exist.");
				}
			}
        }
    }
}
