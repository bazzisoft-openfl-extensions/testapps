package;

import barcode.event.BarcodeScannedEvent;
import common.ITestPanelViewDelegate;
import common.TestPanelView;
import flash.display.Sprite;
import flash.events.Event;
import barcode.Barcode;


class Main extends Sprite implements ITestPanelViewDelegate
{
    private static inline var BUTTON_SCAN_BARCODE = "SCAN BARCODE";
    private static inline var BUTTON_SET_FAKE_SCAN_BARCODE_RESULT = "SET FAKE SCAN BARCODE RESULT";
    private static inline var BUTTON_SIMULATE_BARCODE_SCANNED = "SIMULATE BARCODE SCANNED";
    private static inline var BUTTON_SIMULATE_BARCODE_SCAN_CANCELLED = "SIMULATE BARCODE SCAN CANCELLED";

    private var m_testPanelView:TestPanelView = null;

    public function new()
    {
        super();

        m_testPanelView = new TestPanelView(this, [BUTTON_SCAN_BARCODE, BUTTON_SET_FAKE_SCAN_BARCODE_RESULT, BUTTON_SIMULATE_BARCODE_SCANNED, BUTTON_SIMULATE_BARCODE_SCAN_CANCELLED]);
        addChild(m_testPanelView);

        Barcode.Initialize();
        stage.addEventListener(BarcodeScannedEvent.BARCODE_SCANNED, function(e) { trace(e); } );
        stage.addEventListener(BarcodeScannedEvent.BARCODE_SCAN_CANCELLED, function(e) { trace(e); });
    }

    public function ProcessTestPanelButtonClick(button:String) : Void
    {
        switch (button)
        {
            case BUTTON_SCAN_BARCODE:
                var ret = Barcode.ScanBarcode();
                trace("Barcode.ScanBarcode(): " + Std.string(ret));

            case BUTTON_SET_FAKE_SCAN_BARCODE_RESULT:
                Barcode.SetFakeScanBarcodeResult("123456ABE", "CODE128");
                trace("Barcode.SetFakeScanBarcodeResult(): Set fake barcode '123456ABE'");

            case BUTTON_SIMULATE_BARCODE_SCANNED:
                Barcode.SimulateBarcodeScanned("5463AD28");

            case BUTTON_SIMULATE_BARCODE_SCAN_CANCELLED:
                Barcode.SimulateBarcodeScanCancelled();
        }
    }
}