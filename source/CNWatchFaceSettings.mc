using Toybox.Application;
using Toybox.Lang;
using Toybox.System;
using Toybox.WatchUi;

// Each row in the menu maps to one of these descriptors.  Keeping the
// metadata in one place stops the title, the property key and the option
// list from drifting apart over time.
class CNWatchFaceSettingsMenu extends WatchUi.Menu2 {

    const FIELD_LABEL_LANGUAGES = ["English abbreviations", 0, "Chinese", 1];

    const ON_OFF = [
        Rez.Strings.Yes, 1,
        Rez.Strings.No,  0
    ];
    const TEMPERATURE_UNIT_OPTIONS = [
        Rez.Strings.TemperatureCelsius, 0,
        Rez.Strings.TemperatureFahrenheit, 1
    ];
    const TOP_WEATHER_PAIR_OPTIONS = [
        Rez.Strings.TopWeatherTempHighLow, 1,
        Rez.Strings.TopWeatherTempCondition, 2,
        Rez.Strings.TopWeatherTempFeelsLike, 3,
        Rez.Strings.TopWeatherTempWind, 4,
        Rez.Strings.TopWeatherTempPrecip, 5,
        Rez.Strings.TopWeatherHighLowCondition, 6,
        Rez.Strings.TopWeatherHighLowFeelsLike, 7,
        Rez.Strings.TopWeatherConditionWind, 8,
        Rez.Strings.TopWeatherConditionPrecip, 9,
        Rez.Strings.TopWeatherWindPrecip, 10
    ];
    const PROGRESS_OPTIONS = [
        Rez.Strings.FieldHidden, 0,
        Rez.Strings.ProgressRunDay, 1,
        Rez.Strings.ProgressRunWeek, 2,
        Rez.Strings.ProgressRunMonth, 3,
        Rez.Strings.ProgressCycleDay, 4,
        Rez.Strings.ProgressCycleWeek, 5,
        Rez.Strings.ProgressCycleMonth, 6,
        Rez.Strings.ProgressSteps, 7,
        Rez.Strings.ProgressFloors, 8,
        Rez.Strings.ProgressActiveMinutes, 9,
        Rez.Strings.ProgressBodyBattery, 10
    ];
    const FIELD_OPTIONS = [
        Rez.Strings.FieldHidden, 0,
        // Segment34 order: activity and health
        Rez.Strings.FieldSteps, 1,
        Rez.Strings.FieldActiveMinutesWeek, 26,
        Rez.Strings.FieldActiveMinutes, 14,
        Rez.Strings.FieldDistance, 4,
        Rez.Strings.FieldWeeklyRunningDistance, 55,
        Rez.Strings.FieldWeeklyCyclingDistance, 58,
        Rez.Strings.FieldTotalDistance7Days, 68,
        Rez.Strings.FieldFloors, 2,
        Rez.Strings.FieldMetersClimbed, 60,
        Rez.Strings.FieldRecovery, 13,
        Rez.Strings.FieldVo2MaxRunning, 31,
        Rez.Strings.FieldVo2MaxCycling, 61,
        Rez.Strings.FieldRespirationRate, 49,
        Rez.Strings.FieldHeartRate, 7,
        Rez.Strings.FieldRestingHr, 18,
        Rez.Strings.FieldSpo2, 21,
        Rez.Strings.FieldTotalCalories, 23,
        Rez.Strings.FieldActiveCalories, 3,
        Rez.Strings.FieldElevation, 19,
        Rez.Strings.FieldStress, 6,
        Rez.Strings.FieldBodyBattery, 8,
        Rez.Strings.FieldSunrise, 16,
        Rez.Strings.FieldSunset, 17,
        Rez.Strings.FieldNextSunEvent, 51,
        Rez.Strings.FieldHoursToNextSun, 70,
        Rez.Strings.FieldAltTimezone1, 71,
        Rez.Strings.FieldAltTimezone2, 72,
        Rez.Strings.FieldPressure, 20,
        Rez.Strings.FieldSeaLevelPressure, 63,
        Rez.Strings.FieldWeekNumber, 34,
        Rez.Strings.FieldBattery, 5,
        Rez.Strings.FieldBatteryDays, 29,
        Rez.Strings.FieldNotificationCount, 35,
        Rez.Strings.FieldSolarIntensity, 32,
        Rez.Strings.FieldSensorTemperature, 69,
        Rez.Strings.FieldAlarmCount, 48,
        Rez.Strings.FieldTemperature, 12,
        Rez.Strings.FieldHighTemperature, 36,
        Rez.Strings.FieldLowTemperature, 37,
        Rez.Strings.FieldFeelsLike, 78,
        Rez.Strings.FieldPrecipitationChance, 38,
        Rez.Strings.FieldHumidity, 30,
        Rez.Strings.FieldUvIndex, 73,
        Rez.Strings.FieldLocationName, 53,
        Rez.Strings.FieldNextCalendarEvent, 75,
        Rez.Strings.FieldStepGoal, 15,
        Rez.Strings.FieldFloorsDescended, 25,
        Rez.Strings.FieldActiveMinutesWeekGoal, 28,
        Rez.Strings.FieldRestingCalories, 24,
        Rez.Strings.FieldDailyRunningDistance, 54,
        Rez.Strings.FieldMonthlyRunningDistance, 33,
        Rez.Strings.FieldYearlyRunningDistance, 56,
        Rez.Strings.FieldDailyCyclingDistance, 57,
        Rez.Strings.FieldMonthlyCyclingDistance, 52,
        Rez.Strings.FieldYearlyCyclingDistance, 59,
        Rez.Strings.FieldAverageRestingHr, 45,
        Rez.Strings.FieldHeartRateZone, 41,
        Rez.Strings.FieldSleepScore, 79
    ];
    const BATTERY_DISPLAY_OPTIONS = [
        Rez.Strings.BatteryDisplayPercent, 0,
        Rez.Strings.BatteryDisplayDays, 1
    ];
    const LOW_POWER_OPTIONS = [
        Rez.Strings.LowPowerSimple, 1,
        Rez.Strings.LowPowerFull,   0
    ];

    // Flat four-value descriptors and flat option pairs avoid keeping hundreds
    // of nested constant containers resident before the settings menu opens.
    const DESCRIPTORS = [
        :weatherRow, Rez.Strings.SettingShowWeatherRow, "ShowWeatherRow", ON_OFF,
        :calendarRow, Rez.Strings.SettingShowCalendarRow, "ShowCalendarRow", ON_OFF,
        :ampm,        Rez.Strings.SettingShowAmPm,         "ShowAmPm",         ON_OFF,
        :seconds,     Rez.Strings.SettingShowSecondsActive,"ShowSecondsActive",ON_OFF,
        :topWeather,  Rez.Strings.SettingTopWeatherPair,    "TopWeatherPair",  TOP_WEATHER_PAIR_OPTIONS,
        :temperatureUnit, Rez.Strings.SettingTemperatureUnit,"TemperatureUnit", TEMPERATURE_UNIT_OPTIONS,
        :fieldLabelLanguage, "Field label language", "FieldLabelLanguage", FIELD_LABEL_LANGUAGES,
        :bottomFirst, Rez.Strings.SettingFieldLeft,         "FieldLeft",        FIELD_OPTIONS,
        :bottomCenter,Rez.Strings.SettingFieldCenter,       "FieldCenter",      FIELD_OPTIONS,
        :bottomSecond,Rez.Strings.SettingFieldRight,        "FieldRight",       FIELD_OPTIONS,
        :batteryDisplay,Rez.Strings.SettingBatteryDisplay,  "BatteryDisplayMode",BATTERY_DISPLAY_OPTIONS,
        :lowPower,    Rez.Strings.SettingLowPowerStyle,    "LowPowerStyle",    LOW_POWER_OPTIONS,
        :progressLeft, Rez.Strings.SettingProgressLeftMetric, "ProgressLeftMetric", PROGRESS_OPTIONS,
        :progressRight,Rez.Strings.SettingProgressRightMetric,"ProgressRightMetric",PROGRESS_OPTIONS
    ];

    private var _page as Lang.Number = 0;

    function initialize() {
        Menu2.initialize({:title => load(Rez.Strings.SettingsTitle)});
        setPage(0);
    }

    function currentPage() as Lang.Number { return _page; }

    function mainPageSize() as Lang.Number {
        return System.getSystemStats().totalMemory <= 131072 ? 4 : 12;
    }

    function optionPageSize() as Lang.Number {
        return System.getSystemStats().totalMemory <= 131072 ? 4 : 12;
    }

    function setPage(page as Lang.Number) as Void {
        var item = getItem(0);
        while (item != null) {
            deleteItem(0);
            item = getItem(0);
        }
        _page = page;
        if (page > 0) { addItem(new WatchUi.MenuItem("< " + page, null, :previousSettingsPage, null)); }
        var span = mainPageSize() * 4;
        var start = page * span;
        for (var i = start; i < DESCRIPTORS.size() && i < start + span; i += 4) {
            var id = DESCRIPTORS[i];
            if (id == :lowPower && !SharedAodFields.hasSettings()) { continue; }
            addItem(new WatchUi.MenuItem(load(DESCRIPTORS[i + 1]), subLabel(id), id, null));
        }
        if (start + span < DESCRIPTORS.size()) {
            addItem(new WatchUi.MenuItem((page + 2) + " >", null, :nextSettingsPage, null));
        }
    }

    private function load(id as Lang.ResourceId or Lang.String) as Lang.String {
        if (id instanceof Lang.String) {
            if ((WatchUi.loadResource(Rez.Strings.CalendarLanguage) as Lang.String).equals("zh")) {
                if (id.equals("Field label language")) { return "字段标题语言"; }
                if (id.equals("English abbreviations")) { return "英文缩写"; }
                if (id.equals("Chinese")) { return "中文"; }
            }
            return id;
        }
        return WatchUi.loadResource(id) as Lang.String;
    }

    // Look up the value label of a descriptor, with a sensible fallback.
    function subLabel(id as Lang.Symbol) as Lang.String {
        var key = keyFor(id);
        if (key.length() == 0) { return ""; }
        var value = Application.Properties.getValue(key);
        // Resolve a single label without constructing a complete option list.
        for (var i = 0; i < DESCRIPTORS.size(); i += 4) {
            if (DESCRIPTORS[i] != id) { continue; }
            var pairs = DESCRIPTORS[i + 3];
            if (pairs == null) { return ""; }
            for (var p = 0; p < pairs.size(); p += 2) {
                if (pairs[p + 1] == value) {
                    return load(pairs[p]);
                }
            }
            break;
        }
        return "—";
    }

    function optionLabel(id as Lang.Symbol, option as Lang.Array) as Lang.String {
        return load(option[0]);
    }

    private function appendOptionInRange(options as Lang.Array, label, value, index as Lang.Number, start as Lang.Number, limit as Lang.Number) as Void {
        if (index < start || (limit >= 0 && options.size() >= limit)) { return; }
        var option = [];
        option.add(label);
        option.add(value);
        options.add(option);
    }

    private function supportsSleepScore() as Lang.Boolean {
        try {
            var settings = System.getDeviceSettings();
            if (settings == null || !(settings has :monkeyVersion) || settings.monkeyVersion == null) {
                return false;
            }
            var version = settings.monkeyVersion;
            return version.size() >= 3 &&
                (version[0] > 6 || (version[0] == 6 &&
                (version[1] > 0 || (version[1] == 0 && version[2] >= 2))));
        } catch (e) {
            return false;
        }
    }

    function optionsFor(id as Lang.Symbol) as Lang.Array or Null {
        return optionsRange(id, 0, -1);
    }

    function optionsRange(id as Lang.Symbol, start as Lang.Number, limit as Lang.Number) as Lang.Array or Null {
        var pairs = null;
        for (var i = 0; i < DESCRIPTORS.size(); i += 4) {
            if (DESCRIPTORS[i] == id) { pairs = DESCRIPTORS[i + 3]; break; }
        }
        if (pairs == null) { return null; }
        var options = [];
        var index = 0;
        for (var p = 0; p < pairs.size(); p += 2) {
            if (pairs[p + 1] == 79 && (id == :bottomFirst || id == :bottomCenter || id == :bottomSecond) && !supportsSleepScore()) { continue; }
            appendOptionInRange(options, pairs[p], pairs[p + 1], index, start, limit);
            index += 1;
        }
        return options;
    }

    function keyFor(id as Lang.Symbol) as Lang.String {
        for (var i = 0; i < DESCRIPTORS.size(); i += 4) {
            if (DESCRIPTORS[i] == id) { return DESCRIPTORS[i + 2]; }
        }
        return "";
    }

    // Refresh the on-screen sublabel for a single row after the user picks
    // a new value in the pushView sub-menu.  Idempotent.  Menu2 does not
    // expose a public lookup-by-id, so we walk the visible items.
    function refreshItem(id as Lang.Symbol) as Void {
        var i = 0;
        while (true) {
            var mi = getItem(i);
            if (mi == null) { return; }
            if (mi.getId() == id) {
                mi.setSubLabel(subLabel(id));
                updateItem(mi, i);
                return;
            }
            i += 1;
        }
    }
}

class CNWatchFaceSettingsDelegate extends WatchUi.Menu2InputDelegate {
    private var _menu as CNWatchFaceSettingsMenu;

    function initialize(menu as CNWatchFaceSettingsMenu) {
        Menu2InputDelegate.initialize();
        _menu = menu;
    }

    // Opens a native-looking sub-menu listing every available value for the
    // chosen setting, with a check mark next to the active one.  This
    // replaces the legacy "press SELECT to cycle" behaviour, which forced
    // users to tap many times without seeing the alternatives.
    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId() as Lang.Symbol;
        if (id == :previousSettingsPage || id == :nextSettingsPage) {
            _menu.setPage(id == :previousSettingsPage ? _menu.currentPage() - 1 : _menu.currentPage() + 1);
            return;
        }
        openOptions(id, 0);
    }

    function openOptions(id as Lang.Symbol, page as Lang.Number) as Void {
        var key = _menu.keyFor(id);
        if (key.length() == 0) { return; }
        var submenu = new WatchUi.Menu2({:title => _menu.subLabel(id)});
        fillOptions(submenu, id, page);
        WatchUi.pushView(submenu, new CNWatchFaceSubMenuDelegate(key, id, _menu, self, page, submenu), WatchUi.SLIDE_IMMEDIATE);
    }

    function fillOptions(submenu as WatchUi.Menu2, id as Lang.Symbol, page as Lang.Number) as Void {
        var oldItem = submenu.getItem(0);
        while (oldItem != null) {
            submenu.deleteItem(0);
            oldItem = submenu.getItem(0);
        }
        var size = _menu.optionPageSize();
        var start = page * size;
        var options = _menu.optionsRange(id, start, size);
        if (options == null) { return; }
        var key = _menu.keyFor(id);
        var current = Application.Properties.getValue(key);
        if (page > 0) {
            submenu.addItem(new WatchUi.MenuItem("< " + page, null, :previousPage, null));
        }
        for (var i = 0; i < options.size(); i += 1) {
            var option = options[i] as Lang.Array;
            var value = option[1];
            submenu.addItem(new WatchUi.MenuItem(_menu.optionLabel(id, option),
                value == current ? CNWatchFaceSettingsDelegate.loadString(Rez.Strings.MarkCurrent) : null,
                value, null));
        }
        if (_menu.optionsRange(id, start + size, 1).size() > 0) {
            submenu.addItem(new WatchUi.MenuItem((page + 2) + " >", null, :nextPage, null));
        }
    }

    static function loadString(id as Lang.ResourceId) as Lang.String {
        return WatchUi.loadResource(id) as Lang.String;
    }
}

class CNWatchFaceSubMenuDelegate extends WatchUi.Menu2InputDelegate {
    private var _key as Lang.String;
    private var _id as Lang.Symbol;
    private var _menu as CNWatchFaceSettingsMenu;
    private var _owner as CNWatchFaceSettingsDelegate;
    private var _page as Lang.Number;
    private var _submenu as WatchUi.Menu2;

    function initialize(key as Lang.String, id as Lang.Symbol, menu as CNWatchFaceSettingsMenu, owner as CNWatchFaceSettingsDelegate, page as Lang.Number, submenu as WatchUi.Menu2) {
        Menu2InputDelegate.initialize();
        _key = key;
        _id = id;
        _menu = menu;
        _owner = owner;
        _page = page;
        _submenu = submenu;
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var value = item.getId();
        if (value == :previousPage || value == :nextPage) {
            _page = value == :previousPage ? _page - 1 : _page + 1;
            _owner.fillOptions(_submenu, _id, _page);
            return;
        }
        Application.Properties.setValue(_key, value);
        WatchUi.requestUpdate();
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        _menu.refreshItem(_id);
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }
}
