using Toybox.Lang;
using Toybox.WatchUi;

class CNWatchFaceDelegate extends WatchUi.WatchFaceDelegate {
    private var _view as CNWatchFaceView;

    function initialize(view as CNWatchFaceView) {
        WatchFaceDelegate.initialize();
        _view = view;
    }

    function onPress(clickEvent) as Lang.Boolean {
        var coordinates = clickEvent.getCoordinates();
        if (coordinates == null || coordinates.size() < 2) { return false; }
        return _view.handleFieldLongPress(coordinates[0], coordinates[1]);
    }
}
