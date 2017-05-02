package;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFormat;


class Main extends Sprite 
{
	public function new()     
    {
		super();
        
        var tf = new TextField();
        tf.defaultTextFormat = new TextFormat(null, 30);
        tf.type = TextFieldType.INPUT;
        tf.width = 400;
        tf.height = 70;
        tf.x = 20;
        tf.y = 20;
		tf.border = true;
		tf.borderColor = 0xbbbbff;
        tf.background = true;
        tf.backgroundColor = 0xcccccc;
        addChild(tf);
        
        tf.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent) { trace(e); } );
        tf.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) { trace(e); } );
        tf.addEventListener(Event.CHANGE, function(e:Event) { trace(e); } );
  	}    
}