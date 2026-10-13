using Toybox.Application;
using Toybox.WatchUi;

class CNWatchFaceApp extends Application.AppBase {
    private var _watchFaceView as CNWatchFaceView? = null;

    function initialize() {
        AppBase.initialize();
    }

    function getInitialView() {
        _watchFaceView = new CNWatchFaceView();
        return [_watchFaceView, new CNWatchFaceDelegate(_watchFaceView)];
    }

    function getSettingsView() {
        if (_watchFaceView != null) {
            (_watchFaceView as CNWatchFaceView).releaseDrawingResources();
        }
        var menu = new CNWatchFaceSettingsMenu();
        return [menu, new CNWatchFaceSettingsDelegate(menu)];
    }

    function onSettingsChanged() as Void {
        if (_watchFaceView != null) {
            (_watchFaceView as CNWatchFaceView).onSettingsChanged();
        } else {
            WatchUi.requestUpdate();
        }
    }
}
