package;
    
import common.ITestPanelViewDelegate;
import common.TestPanelView;
import flash.display.Sprite;
import haxe.Utf8;
import nativetext.event.NativeTextEvent;
import nativetext.NativeText;
import nativetext.NativeTextField;
import nativetext.NativeTextFieldAlignment;
import nativetext.NativeTextFieldKeyboardType;
import nativetext.NativeTextFieldReturnKeyType;


class Main extends Sprite implements ITestPanelViewDelegate
{
    private static inline var BUTTON_ADD_TEXT_FIELD = "ADD NATIVE TEXT FIELD";
    private static inline var BUTTON_REMOVE_TEXT_FIELD = "REMOVE NATIVE TEXT FIELD";
    private static inline var BUTTON_GET_TEXT = "GET TEXT";
    private static inline var BUTTON_SET_TEXT = "SET RANDOM TEXT";
    private static inline var BUTTON_TEST_FOCUS = "TEST FOCUS";
    private static inline var BUTTON_TEST_ENABLED_VISIBLE = "TEST ENABLED/VISIBLE";

    private var m_testPanelView:TestPanelView = null;
    private var m_textFieldStack = new Array<NativeTextField>();
    private var m_allKeyboardTypes = NativeTextFieldKeyboardType.createAll();
    private var m_allReturnKeyTypes = NativeTextFieldReturnKeyType.createAll();
    private var m_allAlign = NativeTextFieldAlignment.createAll();

    public function new()
    {
        super();

        NativeText.Initialize();

        m_testPanelView = new TestPanelView(this, [BUTTON_ADD_TEXT_FIELD, BUTTON_REMOVE_TEXT_FIELD, BUTTON_GET_TEXT, BUTTON_SET_TEXT, BUTTON_TEST_FOCUS, BUTTON_TEST_ENABLED_VISIBLE]);
        addChild(m_testPanelView);
    }

    private function StringToHex(s:String) : String
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
                var x = 30;
                var w = 580;
                var y = 110 + m_textFieldStack.length * 65;
                var keyboardType = m_allKeyboardTypes[m_textFieldStack.length % m_allKeyboardTypes.length];
                var returnKeyType = m_allReturnKeyTypes[m_textFieldStack.length % m_allReturnKeyTypes.length];
                var align = m_allAlign[m_textFieldStack.length % m_allAlign.length];                
                var placeholder = Std.string(keyboardType) + "/" + Std.string(returnKeyType) + "/" + Std.string(align);
                
                var tf = new NativeTextField({ x:x, y:y, width:w, fontSize:60, fontColor:0xff0000, placeholder:placeholder, textAlignment:align, keyboardType:keyboardType, returnKeyType:returnKeyType });
                m_textFieldStack.push(tf);

                tf.addEventListener(NativeTextEvent.CHANGE, function(e) { m_testPanelView.WriteLine("Textfield #" + tf.eventDispatcherId + ": " + e); } );
                tf.addEventListener(NativeTextEvent.FOCUS_IN, function(e) { m_testPanelView.WriteLine("Textfield #" + tf.eventDispatcherId + ": " + e); } );
                tf.addEventListener(NativeTextEvent.FOCUS_OUT, function(e) { m_testPanelView.WriteLine("Textfield #" + tf.eventDispatcherId + ": " + e); } );
                tf.addEventListener(NativeTextEvent.RETURN_KEY_PRESSED, function(e) { m_testPanelView.WriteLine("Textfield #" + tf.eventDispatcherId + ": " + e); } );
                
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
                    trace("Hex: " + StringToHex(text));
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
            
            case BUTTON_TEST_FOCUS:
            {
                if (m_textFieldStack.length > 0)
                {
                    var tf = m_textFieldStack[m_textFieldStack.length - 1];
                    
                    m_testPanelView.WriteLine("Text field (#" + tf.eventDispatcherId + ") is focused: " + tf.IsFocused());
                    m_testPanelView.WriteLine("Setting focus to text field (#" + tf.eventDispatcherId + ").");
                    tf.SetFocus();
                    
                    haxe.Timer.delay(function() {
                        m_testPanelView.WriteLine("Text field (#" + tf.eventDispatcherId + ") is focused: " + tf.IsFocused());
                    }, 200);
                    
                    haxe.Timer.delay(function() {
                        m_testPanelView.WriteLine("Clearing focus from text field (#" + tf.eventDispatcherId + ").");
                        tf.ClearFocus();
                        
                        haxe.Timer.delay(function() {
                            m_testPanelView.WriteLine("Text field (#" + tf.eventDispatcherId + ") is focused: " + tf.IsFocused());
                        }, 200);						
                    }, 3000);
                }
                else
                {
                    m_testPanelView.WriteLine("No text fields exist.");
                }
            }
            
            case BUTTON_TEST_ENABLED_VISIBLE:
            {
                if (m_textFieldStack.length > 0)
                {
                    var rnd = Std.random(3);
                    var tf = m_textFieldStack[m_textFieldStack.length - 1];
                    
                    if (0 == rnd)
                    {
                        m_testPanelView.WriteLine("Text field (#" + tf.eventDispatcherId + "): Enabled");
                        tf.Configure( { visible: true, enabled: true } );
                    }
                    else if (1 == rnd)
                    {
                        m_testPanelView.WriteLine("Text field (#" + tf.eventDispatcherId + "): Disabled");
                        tf.Configure( { visible: true, enabled: false } );
                    }
                    else if (2 == rnd)
                    {
                        m_testPanelView.WriteLine("Text field (#" + tf.eventDispatcherId + "): Hidden");
                        tf.Configure( { visible: false, enabled: false } );
                    }
                }
                else
                {
                    m_testPanelView.WriteLine("No text fields exist.");
                }
            }
        }
    }
}
