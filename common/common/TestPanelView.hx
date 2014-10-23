package common;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import haxe.Log;
import haxe.PosInfos;
import haxe.Timer;


class TestPanelView extends Sprite
{
    //---------------------------------
    // Constants
    //---------------------------------

    private static inline var PADDING = 10;
    private static inline var BUTTON_WIDTH = 160;
    private static inline var BUTTON_HEIGHT = 100;
    private static inline var INPUTTEXT_WIDTH = 330;

    #if mobile
    private static inline var FONT_NAME:String = null;
    private static inline var FONT_SIZE:Int = 30;
    private static inline var FONT_SIZE_BUTTON:Int = 22;
    #else
    private static inline var FONT_NAME:String = "Courier New";
    private static inline var FONT_SIZE:Int = 12;
    private static inline var FONT_SIZE_BUTTON:Int = 14;
    #end

    //---------------------------------
    // Attributes
    //---------------------------------

    private var m_delegate:ITestPanelViewDelegate = null;
    private var m_outputLineNum:Int = 1;
    private var m_outputTxt:TextField = null;
    private var m_inputTxt:TextField = null;
    private var m_buttons:Array<Sprite> = new Array<Sprite>();
    private var m_haxeTraceFn = null;

    //---------------------------------
    // Public Methods
    //---------------------------------

	public function new(delegate:ITestPanelViewDelegate, ?buttons:Array<String>, provideTextInputField:Bool = false)
    {
        m_haxeTraceFn = Log.trace;
        Log.trace = WriteTraceMessage;

		super();

        m_delegate = delegate;

        InitializeOutputTextField();
        InitializeButtons(buttons);

        if (provideTextInputField)
        {
            InitializeTextInputField();
        }

        addEventListener(Event.ADDED_TO_STAGE, HandleAddedToStage);
  	}

    public function WriteLine(line:String) : Void
    {
        m_outputTxt.appendText(m_outputLineNum + " ");
        m_outputTxt.appendText(line);
        m_outputTxt.appendText("\n");
        m_outputLineNum++;

        m_outputTxt.scrollV = m_outputTxt.maxScrollV;
    }

    //---------------------------------
    // Private Methods
    //---------------------------------

    private function WriteTraceMessage(v:Dynamic, ?inf:PosInfos) : Void
    {
        m_haxeTraceFn(v, inf);

        var msg:String = "";

        if (inf != null)
        {
            msg += "[" + inf.fileName + ":" + inf.lineNumber + "] ";
        }

        msg += Std.string(v);

        if (inf != null && inf.customParams != null)
        {
            for ( p in inf.customParams )
            {
                msg += "\n" + Std.string(p);
            }
        }

        // Prevent possible threading race conditions
        Timer.delay(function() { WriteLine(msg); }, 0);
    }

    private function HandleAddedToStage(e:Event) : Void
    {
        // Scale everything down for small screens
        if (stage.stageWidth + stage.stageHeight < 1000 && parent.scaleX > 0.9)
        {
            parent.scaleX = 0.5;
            parent.scaleY = 0.5;
            m_outputTxt.scaleX = 2;
            m_outputTxt.scaleY = 2;
            m_outputTxt.defaultTextFormat = new TextFormat(FONT_NAME, FONT_SIZE / 2);
            m_outputTxt.text = m_outputTxt.text;
        }

        stage.removeEventListener(Event.RESIZE, HandleResize);
        stage.addEventListener(Event.RESIZE, HandleResize);
        HandleResize();
    }

    private function HandleResize(?e:Event) : Void
    {
        m_outputTxt.width = stage.stageWidth - PADDING * 2;
        m_outputTxt.height = stage.stageHeight - PADDING * 3 - BUTTON_HEIGHT;
        m_outputTxt.x = PADDING;
        m_outputTxt.y = BUTTON_HEIGHT + PADDING * 2;

        var x:Float = PADDING;

        if (m_inputTxt != null)
        {
            m_inputTxt.x = x;
            m_inputTxt.y = PADDING;
            x += m_inputTxt.width + PADDING;
        }

        for (button in m_buttons)
        {
            button.x = x;
            button.y = PADDING;
            x += button.width + PADDING;
        }
    }

    private function InitializeOutputTextField() : Void
    {
        var tf = new TextField();
        tf.defaultTextFormat = new TextFormat(FONT_NAME, FONT_SIZE);
        tf.type = TextFieldType.DYNAMIC;
        tf.background = true;
        tf.backgroundColor = 0xffffff;
        tf.textColor = 0x999999;
        tf.border = true;
        tf.borderColor = 0x000000;
        tf.multiline = true;
        tf.wordWrap = true;
        tf.text = "OUTPUT LOG:\n";
        
        #if mobile
        tf.selectable = false;
        #end

        addChild(tf);

        m_outputTxt = tf;
    }

    private function InitializeTextInputField() : Void
    {
        var tf = new TextField();
        tf.defaultTextFormat = new TextFormat(FONT_NAME, FONT_SIZE);
        tf.type = TextFieldType.INPUT;
        tf.multiline = true;
        tf.wordWrap = true;
        tf.width = INPUTTEXT_WIDTH;
        tf.height = BUTTON_HEIGHT;
		tf.border = true;
		tf.borderColor = 0xaaccff;
        tf.background = true;
        tf.backgroundColor = 0xffffff;
        addChild(tf);

        m_inputTxt = tf;
    }

    private function InitializeButtons(buttons:Array<String>) : Void
    {
        if (null == buttons || 0 == buttons.length)
        {
            return;
        }

        for (label in buttons)
        {
            var button = CreateButton(label);
            m_buttons.push(button);
            addChild(button);

            button.addEventListener(MouseEvent.CLICK, function(e) { m_delegate.ProcessTestPanelButtonClick(label); } );
        }
    }

    private function CreateButton(label:String) : Sprite
    {
        var buttonLabel = new TextField();
        buttonLabel.type = TextFieldType.DYNAMIC;

        var tf:TextFormat = buttonLabel.getTextFormat();
        tf.size = FONT_SIZE_BUTTON;
        tf.color = 0x000000;
        tf.bold = true;
        tf.align = TextFormatAlign.CENTER;
        buttonLabel.defaultTextFormat = tf;
        buttonLabel.setTextFormat(tf);

        buttonLabel.selectable = false;
        buttonLabel.mouseEnabled = false;
        buttonLabel.multiline = true;
        buttonLabel.wordWrap = true;
        buttonLabel.text = label;
        buttonLabel.width = BUTTON_WIDTH - PADDING;
        buttonLabel.x = PADDING / 2.0;
        buttonLabel.y = (BUTTON_HEIGHT - buttonLabel.textHeight) / 2.0 - 2.0;
        buttonLabel.height = BUTTON_HEIGHT - buttonLabel.y;

        var button = new Sprite();
        var g = button.graphics;
        g.beginFill(0xffcc00);
        g.drawRoundRect(0, 0, BUTTON_WIDTH, BUTTON_HEIGHT, PADDING*2, PADDING*2);
        g.endFill();

        button.addChild(buttonLabel);
        button.buttonMode = true;
        return button;
    }
}