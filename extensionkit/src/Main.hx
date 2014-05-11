package;

import common.ITestPanelViewDelegate;
import common.TestPanelView;
import extensionkit.ExtensionKit;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;


class Main extends Sprite implements ITestPanelViewDelegate
{
    private static inline var BUTTON_TRIGGER_TEST_EVENT = "TRIGGER TEST EVENT";

    private var m_testPanelView:TestPanelView = null;

	public function new()
    {
		super();

        ExtensionKit.Initialize();

        m_testPanelView = new TestPanelView(this, [BUTTON_TRIGGER_TEST_EVENT], true);
        addChild(m_testPanelView);
        
        var s = ExtensionKit.CreateTemporaryFile();
        trace("CreateTemporaryFile: " + s);
        #if !flash
        if (s != null) 
        {
            sys.FileSystem.deleteFile(s);
        }
        #end
        
        trace("GetTempDirectory: " + ExtensionKit.GetTempDirectory());
        trace("GetPrivateAppFilesDirectory: " + ExtensionKit.GetPrivateAppFilesDirectory());
        trace("GetPublicDocumentsDirectory: " + ExtensionKit.GetPublicDocumentsDirectory());        
  	}

    public function ProcessTestPanelButtonClick(button:String) : Void
    {
        switch (button)
        {
            case BUTTON_TRIGGER_TEST_EVENT:
                ExtensionKit.TriggerTestEvent();
        }
    }
}