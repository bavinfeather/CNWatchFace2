using Toybox.ActivityMonitor;
using Toybox.Activity;
using Toybox.Application;
using Toybox.Complications;
using Toybox.Graphics;
using Toybox.Lang;
using Toybox.Math;
using Toybox.Position;
using Toybox.SensorHistory;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.UserProfile;
using Toybox.WatchUi;
using Toybox.Weather;

class CNWatchFaceView extends WatchUi.WatchFace {
    const FIELD_HIDDEN = 0;
    const FIELD_STEPS = 1;
    const FIELD_FLOORS = 2;
    const FIELD_CALORIES = 3;
    const FIELD_DISTANCE = 4;
    const FIELD_BATTERY = 5;
    const FIELD_STRESS = 6;
    const FIELD_HEART = 7;
    const FIELD_BODY_BATTERY = 8;
    const FIELD_SECONDS = 9;
    const FIELD_DATE = 10;
    const FIELD_WEEKDAY = 11;
    const FIELD_TEMPERATURE = 12;
    const FIELD_RECOVERY = 13;
    const FIELD_ACTIVE_MINUTES = 14;
    const FIELD_STEP_GOAL = 15;
    const FIELD_SUNRISE = 16;
    const FIELD_SUNSET = 17;
    const FIELD_RESTING_HR = 18;
    const FIELD_ELEVATION = 19;
    const FIELD_PRESSURE = 20;
    const FIELD_SPO2 = 21;
    const FIELD_LUNAR = 22;
    const FIELD_TOTAL_CALORIES = 23;
    const FIELD_RESTING_CALORIES = 24;
    const FIELD_FLOORS_DESCENDED = 25;
    const FIELD_ACTIVE_MINUTES_WEEK = 26;
    const FIELD_ACTIVE_MINUTES_WEEK_GOAL = 28;
    const FIELD_BATTERY_DAYS = 29;
    const FIELD_HUMIDITY = 30;
    const FIELD_VO2MAX_RUNNING = 31;
    const FIELD_SOLAR_INTENSITY = 32;
    const FIELD_MONTHLY_RUNNING_DISTANCE = 33;
    const FIELD_WEEK_NUMBER = 34;
    const FIELD_NOTIFICATION_COUNT = 35;
    const FIELD_HIGH_TEMPERATURE = 36;
    const FIELD_LOW_TEMPERATURE = 37;
    const FIELD_PRECIPITATION_CHANCE = 38;
    const FIELD_DAY_NIGHT = 39;
    const FIELD_DAYLIGHT_REMAINING = 40;
    const FIELD_HEART_RATE_ZONE = 41;
    const FIELD_MOON_PHASE = 42;
    const FIELD_SOLAR_TERM = 43;
    const FIELD_AVG_RESTING_HR = 45;
    const FIELD_ALARM_COUNT = 48;
    const FIELD_RESPIRATION_RATE = 49;
    const FIELD_WEATHER_CONDITION = 50;
    const FIELD_NEXT_SUN_EVENT = 51;
    const FIELD_MONTHLY_CYCLING_DISTANCE = 52;
    const FIELD_LOCATION_NAME = 53;
    const FIELD_DAILY_RUNNING_DISTANCE = 54;
    const FIELD_WEEKLY_RUNNING_DISTANCE = 55;
    const FIELD_YEARLY_RUNNING_DISTANCE = 56;
    const FIELD_DAILY_CYCLING_DISTANCE = 57;
    const FIELD_WEEKLY_CYCLING_DISTANCE = 58;
    const FIELD_YEARLY_CYCLING_DISTANCE = 59;
    const FIELD_METERS_CLIMBED = 60;
    const FIELD_VO2MAX_CYCLING = 61;
    const FIELD_SEA_LEVEL_PRESSURE = 63;
    const FIELD_TOTAL_DISTANCE_7_DAYS = 68;
    const FIELD_SENSOR_TEMPERATURE = 69;
    const FIELD_HOURS_TO_NEXT_SUN = 70;
    const FIELD_ALT_TIMEZONE_1 = 71;
    const FIELD_ALT_TIMEZONE_2 = 72;
    const FIELD_UV_INDEX = 73;
    const FIELD_NEXT_CALENDAR_EVENT = 75;
    const FIELD_FEELS_LIKE = 78;
    const FIELD_SLEEP_SCORE = 79;

    const COMPLICATION_TYPE_SLEEP_SCORE = 42;

    const DISTANCE_PERIOD_DAY = 0;
    const DISTANCE_PERIOD_WEEK = 1;
    const DISTANCE_PERIOD_MONTH = 2;
    const DISTANCE_PERIOD_YEAR = 3;

    const WX_HIDDEN = 0;
    const WX_TEMP = 1;
    const WX_WIND = 2;
    const WX_HIGH_LOW = 3;
    const WX_CONDITION = 4;
    const WX_PRECIP = 5;
    const WX_FEELS = 6;

    const TOP_WEATHER_TEMP_HIGH_LOW = 1;
    const TOP_WEATHER_TEMP_CONDITION = 2;
    const TOP_WEATHER_TEMP_FEELS = 3;
    const TOP_WEATHER_TEMP_WIND = 4;
    const TOP_WEATHER_TEMP_PRECIP = 5;
    const TOP_WEATHER_HIGH_LOW_CONDITION = 6;
    const TOP_WEATHER_HIGH_LOW_FEELS = 7;
    const TOP_WEATHER_CONDITION_WIND = 8;
    const TOP_WEATHER_CONDITION_PRECIP = 9;
    const TOP_WEATHER_WIND_PRECIP = 10;

    const PROGRESS_HIDDEN = 0;
    const PROGRESS_RUN_DAY = 1;
    const PROGRESS_RUN_WEEK = 2;
    const PROGRESS_RUN_MONTH = 3;
    const PROGRESS_CYCLE_DAY = 4;
    const PROGRESS_CYCLE_WEEK = 5;
    const PROGRESS_CYCLE_MONTH = 6;
    const PROGRESS_STEPS = 7;
    const PROGRESS_FLOORS = 8;
    const PROGRESS_ACTIVE_MINUTES = 9;
    const PROGRESS_BODY_BATTERY = 10;

    const WEATHER_CACHE_SECONDS = 900;
    const WEATHER_RETRY_SECONDS = 60;
    const PROFILE_CACHE_SECONDS = 21600;
    const SLEEP_SCORE_CACHE_SECONDS = 129600;
    const STRESS_CACHE_SECONDS = 600;
    const RECOVERY_COMPLETE_CACHE_SECONDS = 3600;
    const CALENDAR_CACHE_SECONDS = 7200;

    // --- Color palette & default constants (single source of truth) ---
    // properties.xml and settings.xml must stay in lock-step with these.
    // Update all three together when adding a default.
    const COLOR_BLACK        = 0x000000;
    const COLOR_NAVY_DEEP    = 0x000055;     // 85
    const COLOR_NIGHT_NAVY   = 0x1A2A4A;     // 1714762
    const COLOR_DARK_GREEN   = 0x005500;     // 21760
    const COLOR_DARK_RED     = 0x550000;     // 5570560
    const COLOR_WARM_WHITE   = 0xF5E6D3;     // 16115411
    const COLOR_WHITE        = 0xFFFFFF;     // 16777215
    const COLOR_CORAL        = 0xFF6633;     // 16737843
    const COLOR_ORANGE       = 0xFF5500;     // 16733440
    const COLOR_YELLOW       = 0xFFFF00;     // 16776960
    const COLOR_CYAN         = 0x00FFFF;     // 65535
    const COLOR_LIGHT_GRAY   = 0xAAAAAA;     // 11184810
    const COLOR_SOFT_GRAY    = 0xC7CBCB;     // 13093835
    const COLOR_SUNSET       = 0x7A403B;     // 8011835
    const COLOR_FAR_BLUE     = 0x5F7784;     // 6256516
    const COLOR_MID_SLATE    = 0x344A57;     // 3426903
    const COLOR_NEAR_INK     = 0x172B36;     // 1518390
    // Original Classic palette used by the first watch-face project. MIP
    // restores these once because its saved properties outlive a new build.
    // Shared days-per-month table (non-leap).  Allocated once and reused by
    // dayOfYear() and lunarDate() so onUpdate never allocates it per frame.
    const MONTH_DAYS = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    private var _lowPower = false;
    private var _wakeFramePending = false;
    private var _deferActivityHistoryRefresh = false;
    private var _deferSunRefresh = false;
    private var _aodRenderer;
    private var _width = 260;
    private var _height = 260;
    private var _cx = 130;
    // Screen-family layout profile. Fonts and slot spacing are selected once
    // in onLayout; actual text bounds are still measured on the target device.
    private var _profileTimeFont = Graphics.FONT_NUMBER_MEDIUM;
    private var _profileSideFont = Graphics.FONT_XTINY;
    private var _profileTopFieldY = 44;
    private var _profileTimeCenterY = 86;
    private var _profileSideGap = 3;
    private var _profileSideLineGap = 2;
    private var _profileCalendarCenterY = 130;
    private var _profileCalendarFontSize = 15;
    private var _profileVectorTimeScale = 0.30;
    private var _profileExpandVectorTime = false;
    private var _profileVectorSideGap = 0;
    private var _profileVectorCalendarOffset = 0;
    private var _profileTimeInset = 4;
    private var _profileCalendarInset = 14;
    private var _profileStatusGap = 3;
    private var _timeVectorFont = null;
    private var _timeVectorFontChecked = false;
    private var _timeVectorFontKey = -1;
    private var _lunarFont = null;
    private var _lunarFontChecked = false;
    private var _lunarFontKey = -1;
    private var _lunarDateCacheDay = -1;
    private var _lunarDateChinese = null;
    private var _lunarDateEnglish = null;
    private var _sunDiagnostic = -1;
    // AOD cache: filled during active onUpdate frames so minute-based
    // low-power frames can repaint without touching any sensor.
    private var _cachedHeartRate = null;
    private var _cachedBatteryPercent = 0;
    private var _batteryKnown = false;
    // Per-minute cache: seconds must not trigger a complete set of data
    // requests every second.
    private var _dataMinute = -1;
    private var _cachedActivityInfo = null;
    private var _cachedActivity = null;
    private var _cachedConditions = null;
    private var _cachedLocationName = "--";
    private var _weatherCacheTick = -1;
    private var _weatherUpdatedSeconds = 0;
    private var _weatherNextAttemptSeconds = 0;
    private var _weatherStorageLoaded = false;
    private var _cachedStats = null;
    private var _cachedProfile = null;
    private var _cachedHeartRateZones = null;
    private var _profileCacheTick = -1;
    private var _cachedDeviceSettings = null;
    private var _cachedBodyBattery = null;
    private var _bodyBatteryCached = false;
    private var _bodyBatteryStorageLoaded = false;
    private var _cachedSleepScore = null;
    private var _sleepScoreCached = false;
    private var _sleepScoreUpdatedSeconds = 0;
    private var _cachedStress = null;
    private var _stressCached = false;
    private var _stressUpdatedSeconds = 0;
    private var _cachedRecoveryEndSeconds = null;
    private var _recoveryCached = false;
    private var _recoveryUpdatedSeconds = 0;
    private var _cachedElevation = null;
    private var _elevationCached = false;
    private var _cachedPressure = null;
    private var _pressureCached = false;
    private var _cachedSeaLevelPressure = null;
    private var _seaLevelPressureCached = false;
    private var _cachedSpo2 = null;
    private var _spo2Cached = false;
    private var _cachedSensorTemp = null;
    private var _sensorTempCached = false;
    private var _sunCacheTick = -1;
    private var _sunCacheDay = -1;
    private var _sunriseNextAttemptSeconds = 0;
    private var _sunsetNextAttemptSeconds = 0;
    private var _cachedTomorrowSunrise = null;
    private var _tomorrowSunriseNextAttemptSeconds = 0;
    private var _cachedSunrise = null;
    private var _cachedSunset = null;
    private var _sunriseCached = false;
    private var _sunsetCached = false;
    private var _heartRateCached = false;
    // Keep the Segment34-compatible rolling seven-day totals fresh without
    // reading activity history on every redraw.
    private var _activityDistanceCacheKey = -1;
    private var _activityDistanceCacheDay = -1;
    private var _activityDistanceIterator = null;
    private var _pendingRunningDistances = null;
    private var _pendingCyclingDistances = null;
    private var _runningDistances as Lang.Array or Null = null;
    private var _cyclingDistances as Lang.Array or Null = null;
    private var _totalDistanceSevenDays = null;
    private var _activityCacheDay = -1;
    private var _cachedCalendarEvent = "--";
    private var _calendarUpdatedSeconds = 0;
    private var _calendarDay = -1;
    // Chinese lunar-calendar data for 1900–2100.  Keeping this table local
    // makes the calendar available without a phone connection or web request.
    private var _lunarYears as Lang.Array = [
        0x04bd8,0x04ae0,0x0a570,0x054d5,0x0d260,0x0d950,0x16554,0x056a0,0x09ad0,0x055d2,
        0x04ae0,0x0a5b6,0x0a4d0,0x0d250,0x1d255,0x0b540,0x0d6a0,0x0ada2,0x095b0,0x14977,
        0x04970,0x0a4b0,0x0b4b5,0x06a50,0x06d40,0x1ab54,0x02b60,0x09570,0x052f2,0x04970,
        0x06566,0x0d4a0,0x0ea50,0x06e95,0x05ad0,0x02b60,0x186e3,0x092e0,0x1c8d7,0x0c950,
        0x0d4a0,0x1d8a6,0x0b550,0x056a0,0x1a5b4,0x025d0,0x092d0,0x0d2b2,0x0a950,0x0b557,
        0x06ca0,0x0b550,0x15355,0x04da0,0x0a5b0,0x14573,0x052b0,0x0a9a8,0x0e950,0x06aa0,
        0x0aea6,0x0ab50,0x04b60,0x0aae4,0x0a570,0x05260,0x0f263,0x0d950,0x05b57,0x056a0,
        0x096d0,0x04dd5,0x04ad0,0x0a4d0,0x0d4d4,0x0d250,0x0d558,0x0b540,0x0b5a0,0x195a6,
        0x095b0,0x049b0,0x0a974,0x0a4b0,0x0b27a,0x06a50,0x06d40,0x0af46,0x0ab60,0x09570,
        0x04af5,0x04970,0x064b0,0x074a3,0x0ea50,0x06b58,0x05ac0,0x0ab60,0x096d5,0x092e0,
        0x0c960,0x0d954,0x0d4a0,0x0da50,0x07552,0x056a0,0x0abb7,0x025d0,0x092d0,0x0cab5,
        0x0a950,0x0b4a0,0x0baa4,0x0ad50,0x055d9,0x04ba0,0x0a5b0,0x15176,0x052b0,0x0a930,
        0x07954,0x06aa0,0x0ad50,0x05b52,0x04b60,0x0a6e6,0x0a4e0,0x0d260,0x0ea65,0x0d530,
        0x05aa0,0x076a3,0x096d0,0x04afb,0x04ad0,0x0a4d0,0x1d0b6,0x0d250,0x0d520,0x0dd45,
        0x0b5a0,0x056d0,0x055b2,0x049b0,0x0a577,0x0a4b0,0x0aa50,0x1b255,0x06d20,0x0ada0,
        0x14b63,0x09370,0x049f8,0x04970,0x064b0,0x168a6,0x0ea50,0x06aa0,0x1a6c4,0x0aae0,
        0x0a2e0,0x0d2e3,0x0c960,0x0d557,0x0d4a0,0x0da50,0x05d55,0x056a0,0x0a6d0,0x055d4,
        0x052d0,0x0a9b8,0x0a950,0x0b4a0,0x0b6a6,0x0ad50,0x055a0,0x0aba4,0x0a5b0,0x052b0,
        0x0b273,0x06930,0x07337,0x06aa0,0x0ad50,0x14b55,0x04b60,0x0a570,0x054e4,0x0d160,
        0x0e968,0x0d520,0x0daa0,0x06aa6,0x056d0,0x04ae0,0x0a9d4,0x0a2d0,0x0d150,0x0f252,
        0x0d520
    ];

    function initialize() {
        WatchFace.initialize();
    }

    private function numberProperty(key as Lang.String, fallback as Lang.Number) as Lang.Number {
        var value = Application.Properties.getValue(key);
        return value instanceof Lang.Number ? value : fallback;
    }

    private function fieldProperty(key as Lang.String, fallback as Lang.Number) as Lang.Number {
        var value = numberProperty(key, fallback);
        if (value == 74) { return FIELD_LOCATION_NAME; }
        // Values retained by an older installation fall back to the slot's
        // normal default after their selector entries are removed.
        if (value == FIELD_SLEEP_SCORE && !supportsSleepScore()) { return fallback; }
        if (value == 27 || value == 44 || value == 46 || value == 47 ||
            value == 62 || value == 64 || value == 65 || value == 66 ||
            value == 67 || value == 76 || value == 77) {
            return fallback;
        }
        return value;
    }

    private function stringProperty(key as Lang.String, fallback as Lang.String) as Lang.String {
        var value = Application.Properties.getValue(key);
        return value instanceof Lang.String ? value : fallback;
    }

    private function text(resourceId as Lang.ResourceId) as Lang.String {
        return WatchUi.loadResource(resourceId) as Lang.String;
    }

    function onLayout(dc as Graphics.Dc) as Void {
        _width = dc.getWidth();
        _height = dc.getHeight();
        _cx = _width / 2;
        loadLayoutProfile();
        _timeVectorFont = null;
        _timeVectorFontChecked = false;
        _timeVectorFontKey = -1;
        _lunarFont = null;
        _lunarFontChecked = false;
        _lunarFontKey = -1;
    }

    private var _viewVisible = false;

    function onShow() as Void {
        _viewVisible = true;
        updateComplicationSubscriptions();
    }

    function onHide() as Void {
        _viewVisible = false;
        _activityDistanceIterator = null;
        _pendingRunningDistances = null;
        _pendingCyclingDistances = null;
        _activityDistanceCacheKey = -1;
        releaseDrawingResources();
        clearComplicationSubscriptions();
    }

    function releaseDrawingResources() as Void {
        _landscapeBitmap = null;
        _landscapePaths = null;
        _landscapeBands = null;
        _landscapeColors = null;
        _landscapeNextRetrySeconds = 0;
        _timeVectorFont = null;
        _timeVectorFontChecked = false;
        _timeVectorFontKey = -1;
        _lunarFont = null;
        _lunarFontChecked = false;
        _lunarFontKey = -1;
    }

    private function clearComplicationSubscriptions() as Void {
        if (!(Toybox has :Complications)) { return; }
        try {
            Complications.unsubscribeFromAllUpdates();
            Complications.registerComplicationChangeCallback(null);
        } catch (e) {
            // Interval-based reads remain available on unsupported firmware.
        }
    }

    private function updateComplicationSubscriptions() as Void {
        if (!_viewVisible || !(Toybox has :Complications) ||
            !(Complications has :subscribeToUpdates)) { return; }
        clearComplicationSubscriptions();
        try {
            Complications.registerComplicationChangeCallback(method(:onComplicationChanged));
            var types = [];
            var fields = [
                fieldProperty("FieldLeft", FIELD_STEPS),
                fieldProperty("FieldCenter", FIELD_FLOORS),
                fieldProperty("FieldRight", FIELD_CALORIES)
            ];
            for (var i = 0; i < fields.size(); i++) {
                var type = complicationTypeForField(fields[i]);
                if (type != null && types.indexOf(type) == -1) { types.add(type); }
            }
            var metrics = [
                numberProperty("ProgressLeftMetric", PROGRESS_STEPS),
                numberProperty("ProgressRightMetric", PROGRESS_CYCLE_DAY)
            ];
            for (var i = 0; i < metrics.size(); i++) {
                var field = FIELD_HIDDEN;
                if (metrics[i] == PROGRESS_STEPS) { field = FIELD_STEPS; }
                else if (metrics[i] == PROGRESS_FLOORS) { field = FIELD_FLOORS; }
                else if (metrics[i] == PROGRESS_ACTIVE_MINUTES) { field = FIELD_ACTIVE_MINUTES_WEEK; }
                else if (metrics[i] == PROGRESS_BODY_BATTERY) { field = FIELD_BODY_BATTERY; }
                else if (metrics[i] == PROGRESS_RUN_WEEK) { field = FIELD_WEEKLY_RUNNING_DISTANCE; }
                else if (metrics[i] == PROGRESS_CYCLE_WEEK) { field = FIELD_WEEKLY_CYCLING_DISTANCE; }
                var type = complicationTypeForField(field);
                if (type != null && types.indexOf(type) == -1) { types.add(type); }
            }
            for (var i = 0; i < types.size(); i++) {
                try { Complications.subscribeToUpdates(new Complications.Id(types[i])); }
                catch (e) { /* Unavailable metrics keep their polling fallback. */ }
            }
        } catch (e) {
            // Subscription failure does not disable existing data reads.
        }
    }

    function onComplicationChanged(id as Complications.Id) as Void {
        // Mark data dirty; the next scheduled frame refreshes it without
        // starting sensor reads or requesting extra frames during AOD.
        _dataMinute = -1;
    }

    function onEnterSleep() as Void {
        _lowPower = true;
    }

    function onExitSleep() as Void {
        _lowPower = false;
        // Draw valid cached data first; perform due reads on the next frame.
        _wakeFramePending = isAmoledLayout();
        WatchUi.requestUpdate();
    }

    // When the user changes settings, drop the cached vector font so the
    // next onUpdate re-loads it with the current size, and force a redraw.
    function onSettingsChanged() as Void {
        _timeVectorFont = null;
        _timeVectorFontChecked = false;
        _timeVectorFontKey = -1;
        _lunarFont = null;
        _lunarFontChecked = false;
        _lunarFontKey = -1;
        _dataMinute = -1;
        _profileCacheTick = -1;
        _activityDistanceCacheKey = -1;
        _activityDistanceIterator = null;
        _pendingRunningDistances = null;
        _pendingCyclingDistances = null;
        _bodyBatteryCached = false;
        _elevationCached = false;
        _pressureCached = false;
        _seaLevelPressureCached = false;
        _spo2Cached = false;
        _sensorTempCached = false;
        _heartRateCached = false;
        _sleepScoreCached = false;
        _stressCached = false;
        _recoveryCached = false;
        updateComplicationSubscriptions();
        WatchUi.requestUpdate();
    }

    private function y(ratio as Lang.Float) as Lang.Number {
        return (_height * ratio).toNumber();
    }

    private function x(ratio as Lang.Float) as Lang.Number {
        return (_width * ratio).toNumber();
    }

    private function isRound280Layout() as Lang.Boolean {
        return _width >= 275 && _width <= 285;
    }

    // MIP layouts are designed per screen family.  The 280 px family keeps
    // the 280 px geometry as its own baseline instead of enlarging the 260 px
    // layout, leaving the extra diameter available for field spacing.
    private function scalePx(value as Lang.Number) as Lang.Number {
        var designWidth = isRound280Layout() ? 280.0 : 260.0;
        var scaled = ((value * _width / designWidth) + 0.5).toNumber();
        return scaled < 1 ? 1 : scaled;
    }

    private function isAmoledLayout() as Lang.Boolean {
        // Every AMOLED product enabled by this project is a round display of
        // 360 px or larger; all enabled MIP products are 260 px or smaller.
        return _width >= 350;
    }

    private function displayColor(color as Lang.Number) as Lang.Number {
        if (isAmoledLayout()) { return color; }
        // Preserve the distinct warm-white, gray and accent choices on RGB222
        // MIP screens. The generic fallback below remains available for every
        // user-selected color that is not one of the shared palette tones.
        if (color == COLOR_WARM_WHITE) { return 0xFFFFAA; }
        if (color == COLOR_SOFT_GRAY) { return COLOR_LIGHT_GRAY; }
        if (color == COLOR_CORAL || color == COLOR_ORANGE) { return 0xFF5500; }
        // Segment34mkII keeps these soft AMOLED tones vivid on RGB222 MIP.
        if (color == 0xFBCB77) { return 0xFFFF00; }
        if (color == 0x89EFD2) { return 0x00FFFF; }
        if (color == 0x96E0AC) { return 0x00FF00; }
        if (color == 0xFF9161) { return 0xFF5500; }
        if (color == 0x3DA855) { return 0x55AA55; }
        if (color == 0xFFCC33) { return 0xFFAA00; }
        var r = quantizeRgb222Channel((color >> 16) & 0xFF);
        var g = quantizeRgb222Channel((color >> 8) & 0xFF);
        var b = quantizeRgb222Channel(color & 0xFF);
        return (r << 16) | (g << 8) | b;
    }

    // Landscape colors are deliberately mapped by depth, not merely by their
    // nearest RGB222 value. This keeps muted red skies and the three mountain
    // planes readable on MIP screens.
    private function displayLandscapeColor(color as Lang.Number, layer as Lang.Number) as Lang.Number {
        if (isAmoledLayout()) { return color; }
        if (layer == 0) {
            if (color == COLOR_SUNSET || color == 0xA63E32 || color == 0xC45A3C) { return 0xAA5555; }
            if (color == 0x3A2A4A) { return 0x5555AA; }
            if (color == 0x1A2A4A) { return COLOR_NAVY_DEEP; }
            if (color == 0x1E1E1A) { return 0x005555; }
        } else if (layer == 1) {
            if (color == COLOR_FAR_BLUE || color == 0x4A6A7A) { return 0x55AAAA; }
            if (color == 0x304A5A) { return 0x0055AA; }
            if (color == 0x507258) { return 0x55AA55; }
            if (color == 0x6A4242) { return 0xAA5555; }
        } else if (layer == 2) {
            if (color == COLOR_MID_SLATE || color == 0x243747 || color == 0x304A5A) { return 0x0055AA; }
            if (color == 0x223344) { return 0x005555; }
            if (color == 0x4A1018) { return COLOR_DARK_RED; }
        } else {
            if (color == COLOR_NEAR_INK || color == 0x152532) { return COLOR_NAVY_DEEP; }
            if (color == 0x101510) { return COLOR_DARK_GREEN; }
            if (color == 0x261226) { return 0x550055; }
        }
        return displayColor(color);
    }

    private function quantizeRgb222Channel(channel as Lang.Number) as Lang.Number {
        if (channel < 0x2B) { return 0x00; }
        if (channel < 0x80) { return 0x55; }
        if (channel < 0xD5) { return 0xAA; }
        return 0xFF;
    }

    // Jungle keeps exactly one annotated profile in each modern-device PRG.
    // The renderer below owns no device-specific coordinates; each compiled
    // profile supplies visual row anchors and the renderer enforces measured
    // horizontal and vertical bounds inside those slots.
    (:Round240)
    private function loadLayoutProfile() as Void {
        _profileTimeFont = Graphics.FONT_NUMBER_HOT;
        _profileSideFont = Graphics.FONT_TINY;
        _profileTopFieldY = y(0.16);
        _profileTimeCenterY = y(0.34);
        _profileSideGap = 3;
        _profileSideLineGap = 1;
        _profileCalendarCenterY = y(0.515);
        _profileCalendarFontSize = 22;
        _profileVectorTimeScale = 0.40;
        _profileExpandVectorTime = true;
        _profileVectorSideGap = scalePx(12);
        _profileVectorCalendarOffset = scalePx(6);
        _profileTimeInset = 4;
        _profileCalendarInset = 4;
        _profileStatusGap = 2;
    }

    (:Round260)
    private function loadLayoutProfile() as Void {
        _profileTimeFont = Graphics.FONT_NUMBER_HOT;
        _profileSideFont = Graphics.FONT_TINY;
        _profileTopFieldY = y(0.16);
        _profileTimeCenterY = y(0.34);
        _profileSideGap = 6;
        _profileSideLineGap = 1;
        _profileCalendarCenterY = y(0.515);
        _profileCalendarFontSize = 24;
        _profileVectorTimeScale = 0.40;
        _profileExpandVectorTime = true;
        _profileVectorSideGap = scalePx(12);
        _profileVectorCalendarOffset = scalePx(6);
        _profileTimeInset = 4;
        _profileCalendarInset = 4;
        _profileStatusGap = 3;
    }

    (:Round280)
    private function loadLayoutProfile() as Void {
        _profileTimeFont = Graphics.FONT_NUMBER_HOT;
        _profileSideFont = Graphics.FONT_TINY;
        _profileTopFieldY = y(0.16);
        _profileTimeCenterY = y(0.34);
        _profileSideGap = 4;
        _profileSideLineGap = 1;
        _profileCalendarCenterY = y(0.50);
        _profileCalendarFontSize = 26;
        _profileTimeInset = 4;
        _profileCalendarInset = 4;
        _profileStatusGap = 3;
    }

    (:Round390)
    private function loadLayoutProfile() as Void {
        _profileTimeFont = Graphics.FONT_NUMBER_HOT;
        _profileSideFont = Graphics.FONT_TINY;
        _profileTopFieldY = y(0.16);
        _profileTimeCenterY = y(0.34);
        _profileSideGap = 5;
        _profileSideLineGap = 4;
        _profileCalendarCenterY = y(0.50);
        _profileTimeInset = 12;
        _profileCalendarInset = 20;
        _profileStatusGap = 2;
        _profileCalendarFontSize = 34;
    }

    (:Round416)
    private function loadLayoutProfile() as Void {
        _profileTimeFont = Graphics.FONT_NUMBER_HOT;
        _profileSideFont = Graphics.FONT_TINY;
        _profileTopFieldY = y(0.16);
        _profileTimeCenterY = y(0.34);
        _profileSideGap = 9;
        _profileSideLineGap = 4;
        _profileCalendarCenterY = y(0.515);
        _profileCalendarFontSize = 36;
        _profileVectorTimeScale = 0.40;
        _profileExpandVectorTime = true;
        _profileVectorSideGap = scalePx(12);
        _profileVectorCalendarOffset = scalePx(6);
        _profileTimeInset = 12;
        _profileCalendarInset = 20;
        _profileStatusGap = 2;
    }

    (:Round454)
    private function loadLayoutProfile() as Void {
        _profileTimeFont = Graphics.FONT_NUMBER_HOT;
        _profileSideFont = Graphics.FONT_TINY;
        _profileTopFieldY = y(0.16);
        _profileTimeCenterY = y(0.34);
        _profileSideGap = 10;
        _profileSideLineGap = 4;
        _profileCalendarCenterY = y(0.515);
        _profileCalendarFontSize = 39;
        _profileVectorTimeScale = 0.40;
        _profileExpandVectorTime = true;
        _profileVectorSideGap = scalePx(12);
        _profileVectorCalendarOffset = scalePx(6);
        _profileTimeInset = 14;
        _profileCalendarInset = 20;
        _profileStatusGap = 2;
    }

    // Width of the round screen at a particular Y coordinate, minus a safe
    // inset on both sides. Calendar gaps are clamped to this slot width.
    private function roundContentWidthAt(yPos as Lang.Number, inset as Lang.Number) as Lang.Number {
        var diameter = _width < _height ? _width : _height;
        var radius = diameter / 2.0;
        var dy = yPos - (_height / 2.0);
        var squared = radius * radius - dy * dy;
        if (squared <= 0) { return 0; }
        var available = (Math.sqrt(squared) * 2).toNumber() - inset * 2;
        return available > 0 ? available : 0;
    }

    // Four calendar items need the full center chord on MIP. AMOLED calendar
    // rows also use the full chord so their higher pixel density does not make
    // the date look smaller than the MIP version.
    private function calendarInset(itemCount as Lang.Number) as Lang.Number {
        if (isAmoledLayout()) { return 0; }
        return itemCount >= 4 ? 0 : _profileCalendarInset;
    }

    private function calendarMaxFontSize() as Lang.Number {
        return _profileCalendarFontSize + (isAmoledLayout() ? 6 : 0);
    }

    // A system font name does not imply the same pixel box on every device.
    // Test the complete time group against its row slot, then select the
    // largest system-number tier that fits. The top-field profile reserves the
    // separate vertical space needed by the selected number font.
    private function timeFontFits(dc as Graphics.Dc, font, worstTimeText as Lang.String,
                                  reserveSide as Lang.Boolean,
                                  extraSideGap as Lang.Number) as Lang.Boolean {
        var timeWidth = dc.getTextWidthInPixels(worstTimeText, font);
        var sideWidth = dc.getTextWidthInPixels("59", _profileSideFont);
        var pmWidth = dc.getTextWidthInPixels("PM", _profileSideFont);
        if (pmWidth > sideWidth) { sideWidth = pmWidth; }
        var componentWidth = timeWidth +
                             (reserveSide ? _profileSideGap + extraSideGap + sideWidth : 0);

        return componentWidth <= roundContentWidthAt(_profileTimeCenterY, _profileTimeInset);
    }

    private function fittedTimeFont(dc as Graphics.Dc, worstTimeText as Lang.String,
                                    reserveSide as Lang.Boolean) {
        var vectorFont = fittedVectorTimeFont(dc, worstTimeText, reserveSide);
        if (vectorFont != null) { return vectorFont; }
        if (timeFontFits(dc, _profileTimeFont, worstTimeText, reserveSide, 0)) {
            return _profileTimeFont;
        }
        if (_profileTimeFont == Graphics.FONT_NUMBER_HOT &&
            timeFontFits(dc, Graphics.FONT_NUMBER_MEDIUM, worstTimeText, reserveSide, 0)) {
            return Graphics.FONT_NUMBER_MEDIUM;
        }
        return Graphics.FONT_NUMBER_MILD;
    }

    // Vector fonts are present only on newer devices.  Older devices keep the
    // existing system-number fonts even when the setting selects a vector style.
    private function fittedVectorTimeFont(dc as Graphics.Dc, worstTimeText as Lang.String,
                                          reserveSide as Lang.Boolean) {
        var style = numberProperty("TimeFont", 1);
        if (!(Graphics has :getVectorFont)) { return null; }
        // Value 0 came from the short-lived on/off setting; keep it as bold so
        // existing simulator/device properties do not lose the vector choice.
        if (style < 1 || style > 6) { style = 1; }

        var textKey = worstTimeText == "12:59" ? 1 : 0;
        var cacheKey = style * 100000 + _width * 10 + (reserveSide ? 1 : 0) + textKey;
        if (_timeVectorFontChecked && _timeVectorFontKey == cacheKey) {
            return _timeVectorFont;
        }

        _timeVectorFontChecked = true;
        _timeVectorFontKey = cacheKey;
        _timeVectorFont = null;
        var faces = ["RobotoCondensedBold", "NotoSansSCMedium", "KosugiRegular"];
        if (style == 2) {
            faces = ["RobotoCondensedRegular", "RobotoRegular", "KosugiRegular", "NotoSansSCMedium"];
        } else if (style == 3) {
            faces = ["BionicBold", "BionicSemiBold", "BionicMedium", "RobotoCondensedBold", "NotoSansSCMedium"];
        } else if (style == 4) {
            faces = ["NotoSansSCMedium", "RobotoRegular", "RobotoCondensedRegular", "KosugiRegular"];
        } else if (style == 5) {
            faces = ["NanumGothicRegular", "RobotoRegular", "RobotoCondensedRegular", "NotoSansSCMedium"];
        } else if (style == 6) {
            faces = ["RobotoItalic", "RobotoCondensedRegularItalic", "RobotoCondensedRegular", "KosugiRegular"];
        }
        for (var size = (_width * _profileVectorTimeScale).toNumber(); size >= 16; size -= 2) {
            var candidate = null;
            try {
                candidate = Graphics.getVectorFont({:face => faces, :size => size});
            } catch (e) {
                candidate = null;
            }
            if (candidate == null) { break; }
            var extraSideGap = _profileExpandVectorTime ? _profileVectorSideGap : 0;
            if (timeFontFits(dc, candidate, worstTimeText, reserveSide, extraSideGap)) {
                _timeVectorFont = candidate;
                break;
            }
        }
        return _timeVectorFont;
    }

    // AOD must not fetch live data. Keep its optional field restricted to
    // data already cached in the active path or available from the clock.
    private function aodFieldValue(field as Lang.Number, date) as Lang.String {
        if (field == FIELD_HIDDEN) { return ""; }
        if (field == FIELD_BATTERY) { return _batteryKnown ? _cachedBatteryPercent.format("%d") + "%" : "--"; }
        if (field == FIELD_HEART) {
            return _cachedHeartRate == null ? "--" : _cachedHeartRate.toNumber().format("%d");
        }
        if (field == FIELD_DATE) { return Lang.format(text(Rez.Strings.DatePattern), [date.month, date.day]); }
        if (field == FIELD_WEEKDAY) { return weekdayText(date.day_of_week); }
        return "--";
    }

    private function aodFieldWidth(dc as Graphics.Dc, field as Lang.Number, value as Lang.String) as Lang.Number {
        var valueWidth = dc.getTextWidthInPixels(value, Graphics.FONT_TINY);
        var labelWidth = dc.getTextWidthInPixels(fieldLabel(field), Graphics.FONT_XTINY);
        return valueWidth > labelWidth ? valueWidth : labelWidth;
    }

    private function drawAodField(dc as Graphics.Dc, field as Lang.Number, value as Lang.String,
                                  cx as Lang.Number, cy as Lang.Number, color as Lang.Number) as Void {
        if (value == "") { return; }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, cy - scalePx(5), Graphics.FONT_TINY, value,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(cx, cy + scalePx(7), Graphics.FONT_XTINY, fieldLabel(field),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    // Portable AOD; retain MAX2's simple/compact setting and two cached fields.
    private function drawAmoledAod(dc as Graphics.Dc, clock as System.ClockTime, date, displayHour as Lang.Number, simple as Lang.Boolean) as Void {
        if (_aodRenderer == null) { _aodRenderer = new SharedAod(); }
        var fields = [];
        if (!simple) {
            // Refresh only the visible AOD battery; keep the last valid value.
            if (numberProperty("AodLeftField", FIELD_HEART) == FIELD_BATTERY ||
                numberProperty("AodRightField", FIELD_BATTERY) == FIELD_BATTERY) {
                try {
                    var aodBattery = System.getSystemStats().battery;
                    if (aodBattery != null) { _cachedBatteryPercent = aodBattery.toNumber(); _batteryKnown = true; }
                } catch (e) {}
            }
            fields = [
                aodFieldValue(numberProperty("AodLeftField", FIELD_HEART), date),
                aodFieldValue(numberProperty("AodRightField", FIELD_BATTERY), date)
            ];
        }
        _aodRenderer.draw(dc, clock.hour * 60 + clock.min,
            displayHour.format("%02d") + ":" + clock.min.format("%02d"),
            numberProperty("ShowCalendarRow", 1) == 1 ?
                Lang.format(text(Rez.Strings.DatePattern), [date.month, date.day]) : "", fields);
    }

    // AOD uses the once-per-minute onUpdate path. No full-screen drawing
    // is performed in the power-budget-limited partial-update callback.

    // The scene deliberately occupies the whole upper half.  It is a backdrop,
    // not a rectangular panel behind only the time.
    // Linearly interpolate between two 0xRRGGBB colors. t in [0,1]: 0 -> a, 1 -> b.
    private function blendColor(a as Lang.Number, b as Lang.Number, t as Lang.Float) as Lang.Number {
        var ar = (a >> 16) & 0xFF;
        var ag = (a >> 8) & 0xFF;
        var ab = a & 0xFF;
        var br = (b >> 16) & 0xFF;
        var bg = (b >> 8) & 0xFF;
        var bb = b & 0xFF;
        var r = (ar + ((br - ar) * t)).toNumber();
        var g = (ag + ((bg - ag) * t)).toNumber();
        var bl = (ab + ((bb - ab) * t)).toNumber();
        return ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (bl & 0xFF);
    }

    private var _landscapeWidth = 0;
    private var _landscapeHeight = 0;
    private var _landscapeColors = null;
    private var _landscapePaths = null;
    private var _landscapeBands = null;
    private var _landscapeBitmap = null;
    private var _landscapeNextRetrySeconds = 0;

    private function prepareLandscape(sky, far, mid, near) {
        if (_landscapeWidth == _width && _landscapeHeight == _height &&
            _landscapeColors != null && _landscapeColors[0] == sky &&
            _landscapeColors[1] == far && _landscapeColors[2] == mid &&
            _landscapeColors[3] == near) { return; }

        _landscapeBitmap = null;
        _landscapeNextRetrySeconds = 0;
        _landscapeWidth = _width;
        _landscapeHeight = _height;
        _landscapeColors = [sky, far, mid, near];
        // Broad ridges, one offset summit, a narrow shaded face and low foothills.
        _landscapePaths = [
            [
            [x(0.00), y(0.74)],
            [x(0.16), y(0.68)],
            [x(0.35), y(0.61)],
            [x(0.48), y(0.66)],
            [x(0.61), y(0.64)],
            [x(0.82), y(0.70)],
            [x(1.00), y(0.73)],
            [x(1.00), y(1.00)],
            [x(0.00), y(1.00)]
        ],
            [
            [x(0.00), y(0.86)],
            [x(0.19), y(0.82)],
            [x(0.39), y(0.71)],
            [x(0.53), y(0.74)],
            [x(0.68), y(0.58)],
            [x(0.81), y(0.71)],
            [x(1.00), y(0.80)],
            [x(1.00), y(1.00)],
            [x(0.00), y(1.00)]
        ],
            [
            [x(0.68), y(0.58)],
            [x(0.72), y(0.72)],
            [x(0.80), y(0.77)],
            [x(0.90), y(0.76)],
            [x(0.81), y(0.71)]
        ],
            [
            [x(0.00), y(0.93)],
            [x(0.22), y(0.90)],
            [x(0.45), y(0.94)],
            [x(0.72), y(0.88)],
            [x(1.00), y(0.92)],
            [x(1.00), y(1.00)],
            [x(0.00), y(1.00)]
        ]
        ];
        _landscapeBands = [];
        if (!isAmoledLayout()) { return; }
        for (var layer = 0; layer < 4; layer++) {
            var top = 0;
            if (layer > 0) {
                var points = _landscapePaths[layer - 1];
                top = points[0][1];
                for (var p = 1; p < points.size(); p++) {
                    if (points[p][1] < top) { top = points[p][1]; }
                }
            }
            var bands = [];
            var span = _height - top;
            for (var band = 0; band < 64; band++) {
                // Sky and mountain rounding match the original draw paths.
                var yTop = top + (layer == 0 ?
                    (span * band).toFloat() / 64 : span * band / 64).toNumber();
                var yNext = top + (layer == 0 ?
                    (span * (band + 1)).toFloat() / 64 : span * (band + 1) / 64).toNumber();
                var shade = (band + 0.5) / 64 *
                    (layer == 0 ? 0.45 : (layer == 1 ? 0.12 : 0.25));
                var baseColor = _landscapeColors[layer];
                if (layer == 1) {
                    baseColor = blendColor(baseColor, COLOR_LIGHT_GRAY, 0.12);
                }
                var row = [yTop, yNext - yTop,
                    blendColor(baseColor, COLOR_BLACK, shade)];
                if (layer == 3) {
                    row.add(blendColor(blendColor(mid, near, 0.30), COLOR_BLACK, shade));
                }
                bands.add(row);
            }
            _landscapeBands.add(bands);
        }
    }

    private function renderLandscape(dc) {
        if (!isAmoledLayout()) {
            if (_landscapeColors[0] != 0) {
                dc.setColor(_landscapeColors[0], Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(0, 0, _width, _height + 1);
            }
            for (var layer = 0; layer < _landscapePaths.size(); layer++) {
                var color = _landscapeColors[layer < 3 ? layer + 1 : 3];
                if (layer == 2) {
                    color = displayLandscapeColor(blendColor(_landscapeColors[2], _landscapeColors[3], 0.30), 2);
                }
                dc.setColor(color, Graphics.COLOR_TRANSPARENT);
                dc.fillPolygon(_landscapePaths[layer]);
            }
            return;
        }
        for (var layer = 0; layer < 4; layer++) {
            if (layer == 0 && _landscapeColors[0] == 0) { continue; }
            var bands = _landscapeBands[layer];
            for (var band = 0; band < bands.size(); band++) {
                var row = bands[band];
                if (row[1] <= 0) { continue; }
                dc.setColor(row[2], Graphics.COLOR_TRANSPARENT);
                if (layer == 0) {
                    dc.fillRectangle(0, row[0], _width, row[1] + 1);
                } else {
                    dc.setClip(0, row[0], _width, row[1]);
                    if (layer == 3) { dc.setColor(row[3], Graphics.COLOR_TRANSPARENT); }
                    dc.fillPolygon(_landscapePaths[layer - 1]);
                    // Foothills reuse these bands, with a quieter shaded face above.
                    if (layer == 3) {
                        dc.setColor(row[2], Graphics.COLOR_TRANSPARENT);
                        dc.fillPolygon(_landscapePaths[3]);
                    }
                }
            }
            if (layer > 0) { dc.clearClip(); }
        }
    }

    private function drawMountains(dc as Graphics.Dc, sky as Lang.Number, far as Lang.Number, mid as Lang.Number, near as Lang.Number) as Void {
        prepareLandscape(sky, far, mid, near);
        if (isAmoledLayout() && (Graphics has :createBufferedBitmap)) {
            var nowSeconds = Time.now().value();
            if (_landscapeBitmap == null && nowSeconds >= _landscapeNextRetrySeconds) {
                _landscapeNextRetrySeconds = nowSeconds + 60;
                try {
                    var reference = Graphics.createBufferedBitmap({
                        :width => _width, :height => _height
                    });
                    var bitmap = reference.get();
                    if (bitmap != null) {
                        var backgroundDc = bitmap.getDc();
                        backgroundDc.setColor(COLOR_BLACK, COLOR_BLACK);
                        backgroundDc.clear();
                        renderLandscape(backgroundDc);
                        _landscapeBitmap = reference;
                    }
                } catch (e) {
                    _landscapeBitmap = null;
                }
            }
            if (_landscapeBitmap != null) {
                try {
                    var cachedBitmap = _landscapeBitmap.get();
                    if (cachedBitmap == null) { throw new Lang.InvalidValueException("Missing landscape bitmap"); }
                    if (!cachedBitmap.isCached()) {
                        var restoredDc = cachedBitmap.getDc();
                        restoredDc.setColor(COLOR_BLACK, COLOR_BLACK);
                        restoredDc.clear();
                        renderLandscape(restoredDc);
                    }
                    dc.drawBitmap(0, 0, cachedBitmap);
                    return;
                } catch (e) {
                    _landscapeBitmap = null;
                    _landscapeNextRetrySeconds = nowSeconds + 60;
                }
            }
        }
        renderLandscape(dc);
    }

    private function formatMoment(moment) as Lang.String {
        if (moment == null) { return "--:--"; }
        var info = Gregorian.info(moment, Time.FORMAT_SHORT);
        return info.hour.format("%02d") + ":" + info.min.format("%02d");
    }

    private function currentHeartRate() {
        if (_heartRateCached) { return _cachedHeartRate; }
        var latest = null;
        try {
            var activityInfo = _cachedActivityInfo;
            if (activityInfo == null) { activityInfo = Activity.getActivityInfo(); }
            if (activityInfo != null && activityInfo.currentHeartRate != null && activityInfo.currentHeartRate > 0) {
                latest = activityInfo.currentHeartRate;
            }
        } catch (e) {
        }
        if (latest == null && (ActivityMonitor has :getHeartRateHistory)) {
            try {
                var history = ActivityMonitor.getHeartRateHistory(1, true);
                var sample = history == null ? null : history.next();
                if (sample != null && sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                    latest = sample.heartRate;
                }
            } catch (e) {
            }
        }
        if (latest != null) { _cachedHeartRate = latest; }
        _heartRateCached = true;
        return _cachedHeartRate;
    }

    private function restingHeartRate() {
        var profile = _cachedProfile;
        try {
            if (profile != null && profile.restingHeartRate != null) {
                return profile.restingHeartRate;
            }
        } catch (e) {
        }
        return null;
    }

    private function latestOptions() as Lang.Dictionary {
        return {
            :period => 1,
            :order => SensorHistory.ORDER_NEWEST_FIRST
        };
    }

    private function complicationValue(complicationType) {
        try {
            if (!(Toybox has :Complications)) { return null; }
            var complication = Complications.getComplication(new Complications.Id(complicationType));
            return complication == null ? null : complication.value;
        } catch (e) {
            return null;
        }
    }

    private function isFresh(updatedSeconds as Lang.Number, maxAgeSeconds as Lang.Number, nowSeconds as Lang.Number) as Lang.Boolean {
        return updatedSeconds > 0 && nowSeconds >= updatedSeconds &&
            nowSeconds - updatedSeconds <= maxAgeSeconds;
    }

    private function isNumberInRange(value, minimum as Lang.Number, maximum as Lang.Number) as Lang.Boolean {
        return (value instanceof Lang.Number || value instanceof Lang.Float) &&
            value >= minimum && value <= maximum;
    }

    private function supportsSleepScore() as Lang.Boolean {
        try {
            var settings = _cachedDeviceSettings;
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

    private function sleepScore() {
        if (_sleepScoreCached) { return _cachedSleepScore; }
        _sleepScoreCached = true;
        if (!supportsSleepScore()) {
            _cachedSleepScore = null;
            _sleepScoreUpdatedSeconds = 0;
            return null;
        }
        var nowSeconds = Time.now().value();
        var score = complicationValue(COMPLICATION_TYPE_SLEEP_SCORE);
        if (isNumberInRange(score, 0, 100)) {
            _cachedSleepScore = score.toNumber();
            _sleepScoreUpdatedSeconds = nowSeconds;
            return _cachedSleepScore;
        }
        if (isFresh(_sleepScoreUpdatedSeconds, SLEEP_SCORE_CACHE_SECONDS, nowSeconds)) {
            return _cachedSleepScore;
        }
        _cachedSleepScore = null;
        _sleepScoreUpdatedSeconds = 0;
        return null;
    }

    private function loadBodyBatteryCache() as Void {
        if (_bodyBatteryStorageLoaded) { return; }
        _bodyBatteryStorageLoaded = true;
        try {
            var stored = Application.Storage.getValue("CNWatchFace2BodyBattery") as Lang.Number;
            if (stored != null && stored >= 0 && stored <= 100) {
                _cachedBodyBattery = stored;
            }
        } catch (e) {
        }
    }

    private function cacheBodyBattery(value) as Void {
        if (value == null) { return; }
        if (_cachedBodyBattery == value) { return; }
        _cachedBodyBattery = value;
        try {
            Application.Storage.setValue("CNWatchFace2BodyBattery", value);
        } catch (e) {
            // Storage is optional; retain the valid in-memory value either way.
        }
    }

    private function bodyBattery() {
        if (_bodyBatteryCached) { return _cachedBodyBattery; }
        _bodyBatteryCached = true;
        loadBodyBatteryCache();
        var current = ((Toybox has :Complications) ? complicationValue(Complications.COMPLICATION_TYPE_BODY_BATTERY) : null);
        if (current != null) {
            cacheBodyBattery(current);
            return _cachedBodyBattery;
        }
        try {
            if (SensorHistory has :getBodyBatteryHistory) {
                var sample = SensorHistory.getBodyBatteryHistory(latestOptions()).next();
                if (sample != null && sample.data != null) {
                    cacheBodyBattery(sample.data);
                }
            }
        } catch (e) {
        }
        return _cachedBodyBattery;
    }

    private function currentElevation() {
        if (_elevationCached) { return _cachedElevation; }
        _elevationCached = true;
        var elevation = ((Toybox has :Complications) ? complicationValue(Complications.COMPLICATION_TYPE_ALTITUDE) : null);
        if (elevation != null) {
            _cachedElevation = elevation;
            return _cachedElevation;
        }
        try {
            if (SensorHistory has :getElevationHistory) {
                var sample = SensorHistory.getElevationHistory(latestOptions()).next();
                if (sample != null && sample.data != null) { _cachedElevation = sample.data; }
            }
        } catch (e) {
        }
        if (_cachedElevation == null) {
            try {
                var info = Activity.getActivityInfo();
                if (info != null && info.altitude != null) { _cachedElevation = info.altitude; }
            } catch (e) {
            }
        }
        return _cachedElevation;
    }

    private function currentPressure() {
        if (_pressureCached) { return _cachedPressure; }
        _pressureCached = true;
        try {
            if (SensorHistory has :getPressureHistory) {
                var sample = SensorHistory.getPressureHistory(latestOptions()).next();
                if (sample != null && sample.data != null) { _cachedPressure = sample.data; }
            }
        } catch (e) {
        }
        if (_cachedPressure == null) {
            try {
                var info = Activity.getActivityInfo();
                if (info != null && info.rawAmbientPressure != null) {
                    _cachedPressure = info.rawAmbientPressure;
                }
            } catch (e) {
            }
        }
        return _cachedPressure;
    }

    private function currentSeaLevelPressure() {
        if (_seaLevelPressureCached) { return _cachedSeaLevelPressure; }
        _seaLevelPressureCached = true;
        try {
            var info = Activity.getActivityInfo();
            if (info != null && (info has :meanSeaLevelPressure) && info.meanSeaLevelPressure != null) {
                _cachedSeaLevelPressure = info.meanSeaLevelPressure;
            }
        } catch (e) {
        }
        return _cachedSeaLevelPressure;
    }

    private function currentSpo2() {
        if (_spo2Cached) { return _cachedSpo2; }
        _spo2Cached = true;
        var spo2 = ((Toybox has :Complications) ? complicationValue(Complications.COMPLICATION_TYPE_PULSE_OX) : null);
        if (spo2 != null) {
            _cachedSpo2 = spo2;
            return _cachedSpo2;
        }
        try {
            if (SensorHistory has :getOxygenSaturationHistory) {
                var sample = SensorHistory.getOxygenSaturationHistory(latestOptions()).next();
                if (sample != null && sample.data != null) { _cachedSpo2 = sample.data; }
            }
        } catch (e) {
        }
        return _cachedSpo2;
    }

    private function currentSensorTemp() {
        if (_sensorTempCached) { return _cachedSensorTemp; }
        _sensorTempCached = true;
        try {
            if (SensorHistory has :getTemperatureHistory) {
                var sample = SensorHistory.getTemperatureHistory(latestOptions()).next();
                if (sample != null && sample.data != null) { _cachedSensorTemp = sample.data; }
            }
        } catch (e) {
        }
        return _cachedSensorTemp;
    }

    private function currentStress(activity) {
        if (_stressCached) { return _cachedStress; }
        _stressCached = true;
        var nowSeconds = Time.now().value();
        var stress = ((Toybox has :Complications) ? complicationValue(Complications.COMPLICATION_TYPE_STRESS) : null);
        if (!isNumberInRange(stress, 0, 100) &&
            activity != null && (activity has :stressScore) &&
            isNumberInRange(activity.stressScore, 0, 100)) {
            stress = activity.stressScore;
        }
        if (!isNumberInRange(stress, 0, 100)) { try {
            if (SensorHistory has :getStressHistory) {
                var sample = SensorHistory.getStressHistory(latestOptions()).next();
                if (sample != null && isNumberInRange(sample.data, 0, 100)) { stress = sample.data; }
            }
        } catch (e) {
        } }
        if (isNumberInRange(stress, 0, 100)) {
            _cachedStress = stress.toNumber();
            _stressUpdatedSeconds = nowSeconds;
            return _cachedStress;
        }
        if (isFresh(_stressUpdatedSeconds, STRESS_CACHE_SECONDS, nowSeconds)) { return _cachedStress; }
        _cachedStress = null;
        _stressUpdatedSeconds = 0;
        return null;
    }

    private function recoveryHours(activity) {
        var nowSeconds = Time.now().value();
        if (_recoveryCached) { return cachedRecoveryHours(nowSeconds); }
        _recoveryCached = true;
        var minutes = ((Toybox has :Complications) ? complicationValue(Complications.COMPLICATION_TYPE_RECOVERY_TIME) : null);
        var hours = null;
        if ((minutes instanceof Lang.Number || minutes instanceof Lang.Float) && minutes >= 0) {
            hours = minutes / 60.0;
        } else if (activity != null && (activity has :timeToRecovery) &&
            (activity.timeToRecovery instanceof Lang.Number || activity.timeToRecovery instanceof Lang.Float) &&
            activity.timeToRecovery >= 0) {
            hours = activity.timeToRecovery;
        }
        if (hours != null) {
            _cachedRecoveryEndSeconds = nowSeconds + (hours * 3600.0).toNumber();
            _recoveryUpdatedSeconds = nowSeconds;
        }
        return cachedRecoveryHours(nowSeconds);
    }

    private function cachedRecoveryHours(nowSeconds as Lang.Number) {
        if (_cachedRecoveryEndSeconds == null) { return null; }
        if (_cachedRecoveryEndSeconds > nowSeconds) {
            return (_cachedRecoveryEndSeconds - nowSeconds) / 3600.0;
        }
        if (isFresh(_recoveryUpdatedSeconds, RECOVERY_COMPLETE_CACHE_SECONDS, nowSeconds)) { return 0; }
        _cachedRecoveryEndSeconds = null;
        _recoveryUpdatedSeconds = 0;
        return null;
    }

    private function activeMinutesTotal(activity) {
        if (activity == null || !(activity has :activeMinutesDay) || activity.activeMinutesDay == null) { return null; }
        return activity.activeMinutesDay.total;
    }

    private function activeMinutesWeekTotal(activity) {
        if (activity == null || !(activity has :activeMinutesWeek) || activity.activeMinutesWeek == null) { return null; }
        return activity.activeMinutesWeek.total;
    }

    private function activeMinutesWeekGoalPercent(activity) {
        var active = activeMinutesWeekTotal(activity);
        if (activity == null || !(activity has :activeMinutesWeekGoal) || active == null ||
            activity.activeMinutesWeekGoal == null || activity.activeMinutesWeekGoal == 0) { return null; }
        return ((active * 100) / activity.activeMinutesWeekGoal).toNumber();
    }

    private function isCurrentWeek(activityDate, date) as Lang.Boolean {
        var daysSinceMonday = date.day_of_week == Gregorian.DAY_SUNDAY ? 6 : date.day_of_week - Gregorian.DAY_MONDAY;
        var currentDay = dayOfYear(date.month, date.day, date.year);
        var weekStartDay = currentDay - daysSinceMonday;
        var activityDay = dayOfYear(activityDate.month, activityDate.day, activityDate.year);
        if (weekStartDay >= 1) {
            return activityDate.year == date.year && activityDay >= weekStartDay && activityDay <= currentDay;
        }
        if (activityDate.year == date.year) { return activityDay <= currentDay; }
        return activityDate.year == date.year - 1 && activityDay >= daysInYear(activityDate.year) + weekStartDay;
    }

    private function updateActivityDistanceCache(date) as Void {
        var dayKey = (date.year * 13 + date.month) * 32 + date.day;
        if (_deferActivityHistoryRefresh && _activityDistanceCacheDay == dayKey) { return; }
        if (_activityDistanceCacheDay != dayKey) {
            _activityDistanceCacheDay = dayKey;
            _activityDistanceCacheKey = -1;
            _runningDistances = null;
            _cyclingDistances = null;
            _totalDistanceSevenDays = null;
            _activityDistanceIterator = null;
            _pendingRunningDistances = null;
            _pendingCyclingDistances = null;
        }
        var cacheKey = ((((date.year * 12 + date.month) * 31 + date.day) * 24 + date.hour) * 12 + (date.min / 5).toNumber());
        if (_activityDistanceCacheKey == cacheKey && _activityDistanceIterator == null) { return; }
        try {
            if (!(UserProfile has :getUserActivityHistory)) { return; }
            if (_activityDistanceIterator == null) {
                _activityDistanceCacheKey = cacheKey;
                _pendingRunningDistances = [0.0, 0.0, 0.0, 0.0];
                _pendingCyclingDistances = [0.0, 0.0, 0.0, 0.0];
                _activityDistanceIterator = UserProfile.getUserActivityHistory();
                if (_activityDistanceIterator == null || !(_activityDistanceIterator has :next)) {
                    _activityDistanceIterator = null;
                    _pendingRunningDistances = null;
                    _pendingCyclingDistances = null;
                    return;
                }
                _totalDistanceSevenDays = totalDistanceFromHistory();
            }
            // Complete large histories across frames without publishing partial totals.
            for (var count = 0; count < 32; count += 1) {
                var activity = _activityDistanceIterator.next();
                if (activity == null) {
                    _runningDistances = _pendingRunningDistances;
                    _cyclingDistances = _pendingCyclingDistances;
                    _activityDistanceIterator = null;
                    _pendingRunningDistances = null;
                    _pendingCyclingDistances = null;
                    return;
                }
                if ((activity has :startTime) && (activity has :distance) && (activity has :type) &&
                    activity.startTime instanceof Time.Moment &&
                    (activity.distance instanceof Lang.Number || activity.distance instanceof Lang.Float) &&
                    activity.distance >= 0 && activity.distance - activity.distance == 0) {
                    var info = Gregorian.info(activity.startTime, Time.FORMAT_SHORT);
                    var totals = null;
                    if (activity.type == Activity.SPORT_RUNNING) { totals = _pendingRunningDistances; }
                    else if (activity.type == Activity.SPORT_CYCLING) { totals = _pendingCyclingDistances; }
                    if (totals != null && info.year == date.year) {
                        totals[DISTANCE_PERIOD_YEAR] += activity.distance;
                        if (info.month == date.month) {
                            totals[DISTANCE_PERIOD_MONTH] += activity.distance;
                            if (info.day == date.day) { totals[DISTANCE_PERIOD_DAY] += activity.distance; }
                        }
                    }
                    if (totals != null && isCurrentWeek(info, date)) {
                        totals[DISTANCE_PERIOD_WEEK] += activity.distance;
                    }
                }
            }
        } catch (e) {
            // Retain this day's previous successful activity-history totals.
            _activityDistanceIterator = null;
            _pendingRunningDistances = null;
            _pendingCyclingDistances = null;
        }
    }

    private function activityDistance(date, cycling as Lang.Boolean, period as Lang.Number) {
        if (cycling) {
            return _cyclingDistances == null ? null : (_cyclingDistances as Lang.Array)[period];
        }
        return _runningDistances == null ? null : (_runningDistances as Lang.Array)[period];
    }

    private function totalDistanceFromHistory() {
        try {
            var total = 0.0;
            var activity = ActivityMonitor.getInfo();
            if (activity != null && activity.distance != null) { total += activity.distance; }
            var history = ActivityMonitor.getHistory();
            if (history != null) {
                var count = history.size() < 6 ? history.size() : 6;
                for (var i = 0; i < count; i += 1) {
                    if (history[i].distance != null) { total += history[i].distance; }
                }
            }
            return total;
        } catch (e) {
            return null;
        }
    }

    private function distanceFieldValue(field as Lang.Number, date) {
        var cycling = field == FIELD_DAILY_CYCLING_DISTANCE || field == FIELD_WEEKLY_CYCLING_DISTANCE ||
                      field == FIELD_MONTHLY_CYCLING_DISTANCE || field == FIELD_YEARLY_CYCLING_DISTANCE;
        var period = DISTANCE_PERIOD_MONTH;
        if (field == FIELD_DAILY_RUNNING_DISTANCE || field == FIELD_DAILY_CYCLING_DISTANCE) { period = DISTANCE_PERIOD_DAY; }
        else if (field == FIELD_WEEKLY_RUNNING_DISTANCE || field == FIELD_WEEKLY_CYCLING_DISTANCE) { period = DISTANCE_PERIOD_WEEK; }
        else if (field == FIELD_YEARLY_RUNNING_DISTANCE || field == FIELD_YEARLY_CYCLING_DISTANCE) { period = DISTANCE_PERIOD_YEAR; }
        return activityDistance(date, cycling, period);
    }

    private function heartRateZone() as Lang.String {
        var heartRate = _cachedHeartRate;
        if (heartRate == null) { return "--"; }
        var zones = _cachedHeartRateZones;
        if (zones == null || zones.size() < 6) { return "--"; }
        if (heartRate < zones[0]) { return "Z0"; }
        for (var i = 1; i < zones.size(); i += 1) {
            if (heartRate <= zones[i]) { return "Z" + i.format("%d"); }
        }
        return "Z5";
    }

    private function daylightValue(conditions, now as Time.Moment, dayOnly as Lang.Boolean) as Lang.String {
        var sunrise = sunMoment(conditions, now, true);
        var sunset = sunMoment(conditions, now, false);
        if (sunrise == null || sunset == null) { return "--"; }
        var isDay = now.value() >= sunrise.value() && now.value() < sunset.value();
        if (dayOnly) { return isDay ? text(Rez.Strings.ValueDay) : text(Rez.Strings.ValueNight); }
        if (!isDay) { return text(Rez.Strings.ValueNight); }
        var minutes = ((sunset.value() - now.value()) / 60).toNumber();
        var hours = (minutes / 60).toNumber();
        return hours.format("%d") + "h" + (minutes % 60).format("%02d");
    }

    private function nextSunEvent(conditions, now as Time.Moment) {
        var sunrise = sunMoment(conditions, now, true);
        var sunset = sunMoment(conditions, now, false);
        if (sunrise == null || sunset == null) { return null; }
        if (now.value() < sunrise.value()) { return sunrise; }
        if (now.value() < sunset.value()) { return sunset; }
        if (_cachedTomorrowSunrise != null) { return _cachedTomorrowSunrise; }
        var nowSeconds = now.value();
        if (_deferSunRefresh || nowSeconds < _tomorrowSunriseNextAttemptSeconds) { return null; }
        _tomorrowSunriseNextAttemptSeconds = nowSeconds + WEATHER_RETRY_SECONDS;
        try {
            if (conditions == null || conditions.observationLocationPosition == null || !(Weather has :getSunrise)) { return null; }
            _cachedTomorrowSunrise = Weather.getSunrise(conditions.observationLocationPosition, Time.today().add(new Time.Duration(86401)));
            return _cachedTomorrowSunrise;
        } catch (e) {
            return null;
        }
    }

    private function calendarFieldValue() as Lang.String {
        try {
            if (!(Toybox has :Complications)) { return "--"; }
            var complication = Complications.getComplication(new Complications.Id(Complications.COMPLICATION_TYPE_CALENDAR_EVENTS));
            if (complication == null || complication.value == null) { return "--"; }
            return complication.value.toString();
        } catch (e) {
            return "--";
        }
    }

    private function isDisplayedField(field as Lang.Number) as Lang.Boolean {
        return fieldProperty("FieldLeft", FIELD_HIDDEN) == field ||
            fieldProperty("FieldCenter", FIELD_HIDDEN) == field ||
            fieldProperty("FieldRight", FIELD_HIDDEN) == field;
    }

    private function refreshOptionalFieldCache() as Void {
        if (isDisplayedField(FIELD_NEXT_CALENDAR_EVENT)) {
            var now = Time.now();
            var nowSeconds = now.value();
            var date = Gregorian.info(now, Time.FORMAT_SHORT);
            var day = (date.year * 13 + date.month) * 32 + date.day;
            if (_calendarDay != day) {
                _cachedCalendarEvent = "--";
                _calendarUpdatedSeconds = 0;
                _calendarDay = day;
            }
            var event = calendarFieldValue();
            if (event != "--") {
                _cachedCalendarEvent = event;
                _calendarUpdatedSeconds = nowSeconds;
            } else if (!isFresh(_calendarUpdatedSeconds, CALENDAR_CACHE_SECONDS, nowSeconds)) {
                _cachedCalendarEvent = "--";
                _calendarUpdatedSeconds = 0;
            }
        } else {
            _cachedCalendarEvent = "--";
            _calendarUpdatedSeconds = 0;
            _calendarDay = -1;
        }
    }

    private function refreshFieldData(field as Lang.Number, activity, date) as Void {
        if (field == FIELD_HEART || field == FIELD_HEART_RATE_ZONE) { currentHeartRate(); }
        else if (field == FIELD_BODY_BATTERY) { bodyBattery(); }
        else if (field == FIELD_SLEEP_SCORE) { sleepScore(); }
        else if (field == FIELD_STRESS) { currentStress(activity); }
        else if (field == FIELD_RECOVERY) { recoveryHours(activity); }
        else if (field == FIELD_ELEVATION) { currentElevation(); }
        else if (field == FIELD_PRESSURE) { currentPressure(); }
        else if (field == FIELD_SEA_LEVEL_PRESSURE) { currentSeaLevelPressure(); }
        else if (field == FIELD_SPO2) { currentSpo2(); }
        else if (field == FIELD_SENSOR_TEMPERATURE) { currentSensorTemp(); }
    }

    private function refreshProgressData(metric as Lang.Number, date) as Void {
        if (metric == PROGRESS_BODY_BATTERY) {
            bodyBattery();
        }
    }

    private function complicationTypeForField(field as Lang.Number) {
        if (field == FIELD_STEPS || field == FIELD_STEP_GOAL) { return Complications.COMPLICATION_TYPE_STEPS; }
        if (field == FIELD_FLOORS || field == FIELD_FLOORS_DESCENDED || field == FIELD_METERS_CLIMBED) {
            return Complications.COMPLICATION_TYPE_FLOORS_CLIMBED;
        }
        if (field == FIELD_CALORIES || field == FIELD_TOTAL_CALORIES || field == FIELD_RESTING_CALORIES) {
            return Complications.COMPLICATION_TYPE_CALORIES;
        }
        if (field == FIELD_BATTERY || field == FIELD_BATTERY_DAYS) { return Complications.COMPLICATION_TYPE_BATTERY; }
        if (field == FIELD_STRESS) { return Complications.COMPLICATION_TYPE_STRESS; }
        if (field == FIELD_HEART || field == FIELD_RESTING_HR || field == FIELD_AVG_RESTING_HR ||
            field == FIELD_HEART_RATE_ZONE) { return Complications.COMPLICATION_TYPE_HEART_RATE; }
        if (field == FIELD_BODY_BATTERY) { return Complications.COMPLICATION_TYPE_BODY_BATTERY; }
        if (field == FIELD_SLEEP_SCORE) { return COMPLICATION_TYPE_SLEEP_SCORE; }
        if (field == FIELD_DATE) { return Complications.COMPLICATION_TYPE_DATE; }
        if (field == FIELD_WEEKDAY) { return Complications.COMPLICATION_TYPE_WEEKDAY_MONTHDAY; }
        if (field == FIELD_TEMPERATURE) { return Complications.COMPLICATION_TYPE_CURRENT_TEMPERATURE; }
        if (field == FIELD_HIGH_TEMPERATURE || field == FIELD_LOW_TEMPERATURE) {
            return Complications.COMPLICATION_TYPE_HIGH_LOW_TEMPERATURE;
        }
        if (field == FIELD_FEELS_LIKE || field == FIELD_HUMIDITY || field == FIELD_PRECIPITATION_CHANCE ||
            field == FIELD_WEATHER_CONDITION || field == FIELD_LOCATION_NAME || field == FIELD_UV_INDEX) {
            return Complications.COMPLICATION_TYPE_CURRENT_WEATHER;
        }
        if (field == FIELD_RECOVERY) { return Complications.COMPLICATION_TYPE_RECOVERY_TIME; }
        if (field == FIELD_ACTIVE_MINUTES || field == FIELD_ACTIVE_MINUTES_WEEK ||
            field == FIELD_ACTIVE_MINUTES_WEEK_GOAL) { return Complications.COMPLICATION_TYPE_INTENSITY_MINUTES; }
        if (field == FIELD_SUNRISE) { return Complications.COMPLICATION_TYPE_SUNRISE; }
        if (field == FIELD_SUNSET) { return Complications.COMPLICATION_TYPE_SUNSET; }
        if (field == FIELD_ELEVATION) { return Complications.COMPLICATION_TYPE_ALTITUDE; }
        if (field == FIELD_SEA_LEVEL_PRESSURE) { return Complications.COMPLICATION_TYPE_SEA_LEVEL_PRESSURE; }
        if (field == FIELD_SPO2) { return Complications.COMPLICATION_TYPE_PULSE_OX; }
        if (field == FIELD_NOTIFICATION_COUNT) { return Complications.COMPLICATION_TYPE_NOTIFICATION_COUNT; }
        if (field == FIELD_VO2MAX_RUNNING) { return Complications.COMPLICATION_TYPE_VO2MAX_RUN; }
        if (field == FIELD_VO2MAX_CYCLING) { return Complications.COMPLICATION_TYPE_VO2MAX_BIKE; }
        if (field == FIELD_SOLAR_INTENSITY) { return Complications.COMPLICATION_TYPE_SOLAR_INPUT; }
        if (field == FIELD_RESPIRATION_RATE) { return Complications.COMPLICATION_TYPE_RESPIRATION_RATE; }
        if (field == FIELD_NEXT_CALENDAR_EVENT) { return Complications.COMPLICATION_TYPE_CALENDAR_EVENTS; }
        if (field == FIELD_WEEKLY_RUNNING_DISTANCE) { return Complications.COMPLICATION_TYPE_WEEKLY_RUN_DISTANCE; }
        if (field == FIELD_WEEKLY_CYCLING_DISTANCE) { return Complications.COMPLICATION_TYPE_WEEKLY_BIKE_DISTANCE; }
        return null;
    }

    function handleFieldLongPress(px as Lang.Number, py as Lang.Number) as Lang.Boolean {
        if ((_lowPower && isAmoledLayout()) || py < y(0.60) || py > y(0.78)) { return false; }
        var field = FIELD_HIDDEN;
        if (px * 8 < _width * 3) {
            field = fieldProperty("FieldLeft", FIELD_STEPS);
        } else if (px * 8 < _width * 5) {
            field = fieldProperty("FieldCenter", FIELD_FLOORS);
        } else {
            field = fieldProperty("FieldRight", FIELD_CALORIES);
        }
        var complicationType = complicationTypeForField(field);
        if (complicationType == null || !(Toybox has :Complications) || !(Complications has :exitTo)) {
            return false;
        }
        try {
            var id = new Complications.Id(complicationType);
            if (Complications.getComplication(id) == null) { return false; }
            Complications.exitTo(id);
            return true;
        } catch (e) {
            return false;
        }
    }

    private function moonPhase(date) as Lang.String {
        // Reference new moon: 2000-01-06 18:14 UTC.  An eight-step phase is
        // compact enough for every field position and does not require a feed.
        var age = (Time.now().value() / 86400.0) - 10962.76;
        age -= Math.floor(age / 29.53059) * 29.53059;
        return ((age * 8.0 / 29.53059).toNumber() + 1).format("%d") + "/8";
    }

    private function cachedAverageRestingHeartRate() {
        if (_cachedProfile == null || !(_cachedProfile has :averageRestingHeartRate) || _cachedProfile.averageRestingHeartRate == null) { return null; }
        return _cachedProfile.averageRestingHeartRate;
    }

    // Garmin's observed daily resting-calorie model, reverse-engineered by
    // Connect IQ watch-face developers. It aligns more closely with the
    // Calories Glance than the generic Mifflin-St Jeor BMR formula.
    private function estimateBmr(activity) {
        try {
            var profile = _cachedProfile;
            if (profile == null || !(profile has :weight) || !(profile has :height) || !(profile has :birthYear) || profile.weight == null || profile.height == null || profile.birthYear == null) { return null; }
            var weight = profile.weight;          // grams in CIQ
            if (weight <= 0 || profile.height <= 0) { return null; }
            var kg = weight / 1000.0;
            var age = Gregorian.info(Time.now(), Time.FORMAT_SHORT).year - profile.birthYear;
            if (age < 10 || age > 100) { return null; }
            var bmr = 5.2 - 6.116 * age + 7.628 * profile.height + 12.2 * kg;
            if ((profile has :gender) && profile.gender == UserProfile.GENDER_FEMALE) { bmr -= 202.8; }
            return bmr;
        } catch (e) {
            return null;
        }
    }

    // Returns today's active calories: total - Garmin-style resting calories
    // accrued through the current minute.
    // Never negative; returns 0 when no profile is available so the user
    // sees a real value rather than "--".
    private function activeCalories(activity) {
        if (activity == null || !(activity has :calories) || activity.calories == null) { return null; }
        var total = activity.calories;
        var bmr = estimateBmr(activity);
        if (bmr == null || bmr <= 0) { return null; }
        var now = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_SHORT);
        var minutesElapsed = info.hour * 60 + info.min;
        var burnedSoFar = (bmr * minutesElapsed / 1440.0 + 0.5).toNumber();
        var active = total - burnedSoFar;
        if (active < 0) { active = 0; }
        return active.toNumber();
    }

    private function restingCalories(activity) {
        if (activity == null || !(activity has :calories) || activity.calories == null) { return null; }
        var active = activeCalories(activity);
        if (active == null) { return null; }
        var resting = activity.calories - active;
        return resting < 0 ? 0 : resting.toNumber();
    }

    private function batteryDaysRemaining() {
        if (_cachedStats == null || !(_cachedStats has :batteryInDays) || _cachedStats.batteryInDays == null) { return null; }
        return _cachedStats.batteryInDays;
    }

    private function bottomBatteryValue(battery as Lang.Number) as Lang.String {
        if (numberProperty("BatteryDisplayMode", 0) == 1) {
            var days = batteryDaysRemaining();
            if ((days instanceof Lang.Number || days instanceof Lang.Float) && days >= 0 && days - days == 0) {
                return days.toFloat().format("%.1f") + text(Rez.Strings.BatteryDaysSuffix);
            }
        }
        return _batteryKnown ? battery.format("%d") + "%" : "--";
    }

    private function cachedSolarIntensity() {
        if (_cachedStats == null || !(_cachedStats has :solarIntensity) || _cachedStats.solarIntensity == null) { return null; }
        return _cachedStats.solarIntensity;
    }

    private function cachedVo2maxRunning() {
        if (_cachedProfile == null || !(_cachedProfile has :vo2maxRunning) || _cachedProfile.vo2maxRunning == null) { return null; }
        return _cachedProfile.vo2maxRunning;
    }

    private function cachedVo2maxCycling() {
        if (_cachedProfile == null || !(_cachedProfile has :vo2maxCycling) || _cachedProfile.vo2maxCycling == null) { return null; }
        return _cachedProfile.vo2maxCycling;
    }

    private function fieldTimezone(offset as Lang.Number) as Lang.String {
        var utc = Gregorian.utcInfo(Time.now(), Time.FORMAT_SHORT);
        var minute = utc.min + (offset % 60);
        var hour = (utc.hour + Math.floor(offset / 60)) % 24;
        if (minute > 59) { minute -= 60; hour += 1; }
        if (minute < 0) { minute += 60; hour -= 1; }
        if (hour < 0) { hour += 24; }
        if (hour > 23) { hour -= 24; }
        return hour.format("%02d") + ":" + minute.format("%02d");
    }

    private function isoWeekNumber(year as Lang.Number, month as Lang.Number, day as Lang.Number) as Lang.Number {
        var firstDayOfYear = julianDay(year, 1, 1);
        var givenDayOfYear = julianDay(year, month, day);
        var dayOfWeek = (firstDayOfYear + 3) % 7;
        var weekOfYear = (givenDayOfYear - firstDayOfYear + dayOfWeek + 4) / 7;
        if (weekOfYear == 53) {
            if (dayOfWeek == 6 || (dayOfWeek == 5 && isLeapYear(year))) { return weekOfYear; }
            return 1;
        }
        if (weekOfYear == 0) {
            firstDayOfYear = julianDay(year - 1, 1, 1);
            dayOfWeek = (firstDayOfYear + 3) % 7;
            return (givenDayOfYear - firstDayOfYear + dayOfWeek + 4) / 7;
        }
        return weekOfYear;
    }

    private function julianDay(year as Lang.Number, month as Lang.Number, day as Lang.Number) as Lang.Number {
        var a = (14 - month) / 12;
        var y = year + 4800 - a;
        var m = month + 12 * a - 3;
        return day + ((153 * m + 2) / 5) + 365 * y + (y / 4) - (y / 100) + (y / 400) - 32045;
    }

    private function isLeapYear(year as Lang.Number) as Lang.Boolean {
        return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
    }

    private function stepGoalPercent(activity) {
        if (activity == null || !(activity has :steps) || !(activity has :stepGoal) || activity.steps == null || activity.stepGoal == null || activity.stepGoal == 0) {
            return null;
        }
        var pct = (activity.steps * 100) / activity.stepGoal;
        if (pct > 999) { pct = 999; }
        return pct;
    }

    private function gregorianLeapYear(year as Lang.Number) as Lang.Boolean {
        return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
    }

    private function lunarYearInfo(year as Lang.Number) as Lang.Number {
        return _lunarYears[(year - 1900).toNumber()] as Lang.Number;
    }

    private function lunarLeapMonth(year as Lang.Number) as Lang.Number {
        return lunarYearInfo(year) & 0x0f;
    }

    private function lunarLeapDays(year as Lang.Number) as Lang.Number {
        var month = lunarLeapMonth(year);
        if (month == 0) { return 0; }
        return (lunarYearInfo(year) & 0x10000) != 0 ? 30 : 29;
    }

    private function lunarMonthDays(year as Lang.Number, month as Lang.Number) as Lang.Number {
        return (lunarYearInfo(year) & (0x10000 >> month)) != 0 ? 30 : 29;
    }

    private function lunarYearDays(year as Lang.Number) as Lang.Number {
        // Keep the data-slot path shallow by reading the year's flags directly.
        var info = _lunarYears[(year - 1900).toNumber()] as Lang.Number;
        var days = 348;
        for (var mask = 0x8000; mask > 0x8; mask >>= 1) {
            if ((info & mask) != 0) { days += 1; }
        }
        if ((info & 0x0f) != 0) { days += (info & 0x10000) != 0 ? 30 : 29; }
        return days;
    }

    // Select the largest Chinese vector-font size whose complete row fits the
    // center chord without entering the status row. The calendar has its own
    // profile anchor because Garmin number fonts can contain large internal
    // leading that does not match the visible digit bounds.
    private function fittedCalendarFont(dc as Graphics.Dc, items as Lang.Array,
                                        itemCount as Lang.Number, cacheKey as Lang.Number) {
        if (!(Graphics has :getVectorFont) || itemCount == 0) { return null; }
        if (_lunarFontChecked && _lunarFontKey == cacheKey) { return _lunarFont; }
        _lunarFontChecked = true;
        _lunarFontKey = cacheKey;
        _lunarFont = null;

        // Venu 3 has a tight watch-face memory budget. Probe in two-pixel
        // steps so the first calendar render does not allocate dozens of
        // short-lived vector-font objects.
        for (var size = calendarMaxFontSize(); size >= 8; size -= 2) {
            var candidate = null;
            try {
                candidate = Graphics.getVectorFont({:face => "NotoSansSCMedium", :size => size});
            } catch (e) {
                candidate = null;
            }
            if (candidate == null) { break; }

            var contentWidth = 0;
            for (var i = 0; i < items.size(); i += 1) {
                contentWidth += dc.getTextWidthInPixels(items[i], candidate);
            }
            var calendarCenterY = _profileCalendarCenterY + _profileVectorCalendarOffset;
            var availableWidth = roundContentWidthAt(calendarCenterY, calendarInset(itemCount));
            var minimumGapWidth = itemCount > 1 && itemCount < 4 ? itemCount - 1 : 0;
            var verticalFits = true;
            if (!_profileExpandVectorTime) {
                var fontH = dc.getFontHeight(candidate);
                var dateBottom = calendarCenterY + (fontH / 2).toNumber();
                var statusTop = y(0.61) -
                                (dc.getFontHeight(Graphics.FONT_XTINY) / 2).toNumber();
                verticalFits = dateBottom + _profileStatusGap <= statusTop;
            }
            if (contentWidth + minimumGapWidth <= availableWidth && verticalFits) {
                _lunarFont = candidate;
                break;
            }
        }
        return _lunarFont;
    }

    // Devices without vector fonts still get the largest built-in font whose
    // complete row fits horizontally instead of always falling back to XTINY.
    private function fittedLegacyCalendarFont(dc as Graphics.Dc, items as Lang.Array,
                                               itemCount as Lang.Number) {
        var fonts = [Graphics.FONT_MEDIUM, Graphics.FONT_SMALL,
                     Graphics.FONT_TINY, Graphics.FONT_XTINY];
        for (var f = 0; f < fonts.size(); f += 1) {
            var candidate = fonts[f];
            var contentWidth = 0;
            for (var i = 0; i < items.size(); i += 1) {
                contentWidth += dc.getTextWidthInPixels(items[i], candidate);
            }
            var availableWidth = roundContentWidthAt(_profileCalendarCenterY, calendarInset(itemCount));
            var minimumGapWidth = itemCount > 1 && itemCount < 4 ? itemCount - 1 : 0;
            if (contentWidth + minimumGapWidth <= availableWidth) {
                return candidate;
            }
        }
        return Graphics.FONT_XTINY;
    }

    // Converts the local Gregorian calendar date to a compact Chinese lunar
    // date.  The table's supported range is 1900–2100.

    private function lunarDate(date, chinese as Lang.Boolean) as Lang.String {
        var day = (date.year * 13 + date.month) * 32 + date.day;
        if (_lunarDateCacheDay != day) {
            _lunarDateCacheDay = day;
            _lunarDateChinese = null;
            _lunarDateEnglish = null;
        }
        if (chinese) {
            if (_lunarDateChinese == null) { _lunarDateChinese = calculateLunarDate(date, true); }
            return _lunarDateChinese;
        }
        if (_lunarDateEnglish == null) { _lunarDateEnglish = calculateLunarDate(date, false); }
        return _lunarDateEnglish;
    }

    private function calculateLunarDate(date, chinese as Lang.Boolean) as Lang.String {
        var year = date.year;
        if (year < 1900 || year > 2100) { return chinese ? "--" : "L--"; }
        // 1900-01-01..1900-01-30 fall in lunar year 1899, which the table
        // does not cover.  Without this guard the offset becomes negative
        // and dayNames[offset] would read past the start of the array.
        if (year == 1900 && date.month == 1 && date.day < 31) {
            return chinese ? "--" : "L--";
        }

        var solarMonthDays = MONTH_DAYS;
        var offset = date.day - 31;
        for (var solarYear = 1900; solarYear < year; solarYear += 1) {
            offset += gregorianLeapYear(solarYear) ? 366 : 365;
        }
        for (var solarMonth = 1; solarMonth < date.month; solarMonth += 1) {
            offset += solarMonthDays[solarMonth - 1];
            if (solarMonth == 2 && gregorianLeapYear(year)) { offset += 1; }
        }

        var lunarYear = 1900;
        var yearDays = lunarYearDays(lunarYear);
        while (offset >= yearDays && lunarYear < 2101) {
            offset -= yearDays;
            lunarYear += 1;
            if (lunarYear <= 2100) { yearDays = lunarYearDays(lunarYear); }
        }

        var leap = lunarLeapMonth(lunarYear);
        var lunarMonth = 1;
        var isLeap = false;
        var monthDays = lunarMonthDays(lunarYear, lunarMonth);
        while (offset >= monthDays) {
            offset -= monthDays;
            if (leap != 0 && lunarMonth == leap && !isLeap) {
                isLeap = true;
                monthDays = lunarLeapDays(lunarYear);
            } else {
                if (isLeap) { isLeap = false; }
                lunarMonth += 1;
                monthDays = lunarMonthDays(lunarYear, lunarMonth);
            }
        }

        if (chinese) {
            var monthNames = ["正","二","三","四","五","六","七","八","九","十","冬","腊"];
            var dayNames = ["初一","初二","初三","初四","初五","初六","初七","初八","初九","初十",
                            "十一","十二","十三","十四","十五","十六","十七","十八","十九","二十",
                            "廿一","廿二","廿三","廿四","廿五","廿六","廿七","廿八","廿九","三十"];
            return (isLeap ? "闰" : "") + monthNames[lunarMonth - 1] + "月" + dayNames[offset];
        }

        // Fallback for devices that do not provide the Chinese vector font.
        return (isLeap ? "R" : "L") + lunarMonth.format("%02d") + "/" + (offset + 1).format("%02d");
    }

    // --- 24 solar terms (节气) -------------------------------------------------
    // Names in calendar order, starting from 小寒 (early January).
    private var _solarTermNames as Lang.Array = [
        "小寒","大寒","立春","雨水","惊蛰","春分","清明","谷雨",
        "立夏","小满","芒种","夏至","小暑","大暑","立秋","处暑",
        "白露","秋分","寒露","霜降","立冬","小雪","大雪","冬至"
    ];
    private var _solarTermNamesEnglish as Lang.Array = [
        "Min Cold","Maj Cold","Spring","Rain Water","Insects","Spring Eq","Clear","Grain Rain",
        "Summer","Grain Full","Grain Ear","Summer Sol","Min Heat","Maj Heat","Autumn","End Heat",
        "White Dew","Autumn Eq","Cold Dew","Frost","Winter","Min Snow","Maj Snow","Winter Sol"
    ];
    // 寿星天文公式 century constants (C) for each term (accurate ~1901-2100, ±1 day).
    private var _solarTermC as Lang.Array = [
        5.4055, 20.12, 3.87, 18.73, 5.63, 20.646, 4.81, 20.1,
        5.52, 20.888, 5.678, 21.37, 7.108, 22.83, 7.5, 23.13,
        7.646, 23.042, 8.318, 23.438, 7.438, 22.36, 7.18, 21.94
    ];

    // Day of the month for solar term `index` in `year`, via the 寿星 formula:
    //   day = floor(Y * 0.2422 + C) - floor((Y-1) / 4),  Y = year % 100
    private function solarTermDay(year as Lang.Number, index as Lang.Number) as Lang.Number {
        var y = year % 100;
        var c = _solarTermC[index] as Lang.Float;
        return ((y * 0.2422 + c).toNumber() - ((y - 1) / 4).toNumber());
    }

    // Calendar month (1-12) that solar term `index` falls in.
    private function solarTermMonth(index as Lang.Number) as Lang.Number {
        return (index / 2).toNumber() + 1;   // Monkey C integer division
    }

    private function dayOfYear(month as Lang.Number, day as Lang.Number, year as Lang.Number) as Lang.Number {
        var monthDays = MONTH_DAYS;
        var doy = day;
        for (var m = 1; m < month; m += 1) {
            doy += monthDays[m - 1];
        }
        if (month > 2 && gregorianLeapYear(year)) { doy += 1; }
        return doy;
    }

    private function daysInYear(year as Lang.Number) as Lang.Number {
        return gregorianLeapYear(year) ? 366 : 365;
    }

    // Returns [daysUntil, nameIndex]; daysUntil is 0 on a term day. Rolls over
    // to 小寒 of the next year when no term remains in the current year.
    private function nextSolarTerm(date) as Lang.Array {
        var year = date.year;
        var todayDoy = dayOfYear(date.month, date.day, year);
        for (var i = 0; i < 24; i += 1) {
            var m = solarTermMonth(i);
            var d = solarTermDay(year, i);
            if (dayOfYear(m, d, year) >= todayDoy) {
                return [dayOfYear(m, d, year) - todayDoy, i];
            }
        }
        var d0 = solarTermDay(year + 1, 0);
        return [(daysInYear(year) - todayDoy) + dayOfYear(solarTermMonth(0), d0, year + 1), 0];
    }

    private function solarTermText(date) as Lang.String {
        var res = nextSolarTerm(date);
        var days = res[0] as Lang.Number;
        var names = isChineseCalendar() ? _solarTermNames : _solarTermNamesEnglish;
        var name = names[res[1] as Lang.Number];
        if (days == 0) {
            return Lang.format(text(Rez.Strings.SolarTermTodayPattern), [name]);
        }
        return Lang.format(text(Rez.Strings.SolarTermFuturePattern), [name, days]);
    }

    private function reportSunDiagnostic(status as Lang.Number, message as Lang.String) as Void {
        // Report only when the failure state changes. This keeps second-by-second
        // watch-face updates from flooding the simulator log.
        if (_sunDiagnostic != status) {
            _sunDiagnostic = status;
            System.println(message);
        }
    }

    private function sunMoment(conditions, now as Time.Moment, rising as Lang.Boolean) {
        var date = Gregorian.info(now, Time.FORMAT_SHORT);
        var dayKey = (date.year * 13 + date.month) * 32 + date.day;
        if (_sunCacheTick != _weatherCacheTick || _sunCacheDay != dayKey) {
            _sunCacheTick = _weatherCacheTick;
            _sunCacheDay = dayKey;
            _cachedSunrise = null;
            _cachedSunset = null;
            _sunriseCached = false;
            _sunsetCached = false;
            _sunriseNextAttemptSeconds = 0;
            _sunsetNextAttemptSeconds = 0;
            _cachedTomorrowSunrise = null;
            _tomorrowSunriseNextAttemptSeconds = 0;
        }
        if (rising && _sunriseCached) { return _cachedSunrise; }
        if (!rising && _sunsetCached) { return _cachedSunset; }
        var nowSeconds = now.value();
        if (rising) {
            if (nowSeconds < _sunriseNextAttemptSeconds) { return null; }
            _sunriseNextAttemptSeconds = nowSeconds + WEATHER_RETRY_SECONDS;
        } else {
            if (nowSeconds < _sunsetNextAttemptSeconds) { return null; }
            _sunsetNextAttemptSeconds = nowSeconds + WEATHER_RETRY_SECONDS;
        }

        var moment = null;
        try {
            if (conditions == null) {
                reportSunDiagnostic(1, "Sun data: weather conditions are unavailable");
            } else if (conditions.observationLocationPosition == null) {
                reportSunDiagnostic(2, "Sun data: weather location is unavailable; check Positioning permission and weather sync");
            } else if (rising) {
                if (!(Weather has :getSunrise)) {
                    reportSunDiagnostic(3, "Sun data: Weather.getSunrise is unsupported");
                } else {
                    moment = Weather.getSunrise(conditions.observationLocationPosition, Time.today());
                    if (moment == null) {
                        reportSunDiagnostic(4, "Sun data: Weather.getSunrise returned null");
                    } else {
                        _sunDiagnostic = 0;
                    }
                }
            } else if (!(Weather has :getSunset)) {
                reportSunDiagnostic(5, "Sun data: Weather.getSunset is unsupported");
            } else {
                moment = Weather.getSunset(conditions.observationLocationPosition, Time.today());
                if (moment == null) {
                    reportSunDiagnostic(6, "Sun data: Weather.getSunset returned null");
                } else {
                    _sunDiagnostic = 0;
                }
            }
        } catch (e) {
            reportSunDiagnostic(7, "Sun data: calculation raised an exception");
        }
        if (rising) {
            if (moment != null) { _cachedSunrise = moment; }
            _sunriseCached = moment != null;
        } else {
            if (moment != null) { _cachedSunset = moment; }
            _sunsetCached = moment != null;
        }
        return moment;
    }

    private function extendedFieldValue(field as Lang.Number, activity, date, conditions, now as Time.Moment) {
        if (field == FIELD_TOTAL_DISTANCE_7_DAYS) {
            return _totalDistanceSevenDays == null ? "--" : (_totalDistanceSevenDays / 100000.0).format("%.1f");
        }
        if (field == FIELD_DAILY_RUNNING_DISTANCE || field == FIELD_WEEKLY_RUNNING_DISTANCE ||
            field == FIELD_MONTHLY_RUNNING_DISTANCE || field == FIELD_YEARLY_RUNNING_DISTANCE ||
            field == FIELD_DAILY_CYCLING_DISTANCE || field == FIELD_WEEKLY_CYCLING_DISTANCE ||
            field == FIELD_MONTHLY_CYCLING_DISTANCE || field == FIELD_YEARLY_CYCLING_DISTANCE) {
            var distance = distanceFieldValue(field, date);
            return distance == null ? "--" : (distance / 1000.0).format("%.1f");
        }
        if (field == FIELD_WEEK_NUMBER) { return isoWeekNumber(date.year, date.month, date.day).format("%d"); }
        if (field == FIELD_NOTIFICATION_COUNT) {
            return _cachedDeviceSettings == null || !(_cachedDeviceSettings has :notificationCount) || _cachedDeviceSettings.notificationCount == null ? "--" : _cachedDeviceSettings.notificationCount.format("%d");
        }
        if (field == FIELD_HIGH_TEMPERATURE) {
            return conditions == null || !(conditions has :highTemperature) || conditions.highTemperature == null ? "--" : formatTemperature(conditions.highTemperature);
        }
        if (field == FIELD_FEELS_LIKE) {
            return conditions == null || !(conditions has :feelsLikeTemperature) || conditions.feelsLikeTemperature == null ? "--" : formatTemperature(conditions.feelsLikeTemperature);
        }
        if (field == FIELD_LOW_TEMPERATURE) {
            return conditions == null || !(conditions has :lowTemperature) || conditions.lowTemperature == null ? "--" : formatTemperature(conditions.lowTemperature);
        }
        if (field == FIELD_PRECIPITATION_CHANCE) {
            return conditions == null || !(conditions has :precipitationChance) || conditions.precipitationChance == null ? "--" : conditions.precipitationChance.format("%d") + "%";
        }
        if (field == FIELD_DAY_NIGHT) { return daylightValue(conditions, now, true); }
        if (field == FIELD_DAYLIGHT_REMAINING) { return daylightValue(conditions, now, false); }
        if (field == FIELD_HEART_RATE_ZONE) { return heartRateZone(); }
        if (field == FIELD_MOON_PHASE) { return moonPhase(date); }
        if (field == FIELD_SOLAR_TERM) { return solarTermText(date); }
        if (field == FIELD_AVG_RESTING_HR) {
            var averageRest = cachedAverageRestingHeartRate();
            return averageRest == null ? "--" : averageRest.format("%d");
        }
        if (field == FIELD_ALARM_COUNT) {
            return _cachedDeviceSettings == null || !(_cachedDeviceSettings has :alarmCount) || _cachedDeviceSettings.alarmCount == null ? "--" : _cachedDeviceSettings.alarmCount.format("%d");
        }
        if (field == FIELD_RESPIRATION_RATE) {
            return activity == null || !(activity has :respirationRate) || activity.respirationRate == null ? "--" : activity.respirationRate.format("%.0f");
        }
        if (field == FIELD_WEATHER_CONDITION) {
            return conditions == null || !(conditions has :condition) ? "--" : weatherText(conditions.condition);
        }
        if (field == FIELD_NEXT_SUN_EVENT) { return formatMoment(nextSunEvent(conditions, now)); }
        if (field == FIELD_HOURS_TO_NEXT_SUN) {
            var next = nextSunEvent(conditions, now);
            return next == null ? "--" : ((next.value() - now.value()) / 3600.0).format("%.1f");
        }
        if (field == FIELD_ALT_TIMEZONE_1) { return fieldTimezone(numberProperty("Timezone1Offset", 0)); }
        if (field == FIELD_ALT_TIMEZONE_2) { return fieldTimezone(numberProperty("Timezone2Offset", 0)); }
        if (field == FIELD_SENSOR_TEMPERATURE) {
            var sensorTemp = _cachedSensorTemp;
            return sensorTemp == null ? "--" : formatTemperature(sensorTemp);
        }
        if (field == FIELD_UV_INDEX) {
            return conditions == null || !(conditions has :uvIndex) || conditions.uvIndex == null ? "--" : conditions.uvIndex.format("%d");
        }
        if (field == FIELD_NEXT_CALENDAR_EVENT) { return _cachedCalendarEvent; }
        if (field == FIELD_LOCATION_NAME) { return _cachedLocationName; }
        return null;
    }

    private function fieldLabel(field as Lang.Number) as Lang.String {
        if (field == FIELD_STEPS) { return text(Rez.Strings.FieldSteps); }
        if (field == FIELD_FLOORS) { return text(Rez.Strings.FieldFloors); }
        if (field == FIELD_CALORIES) { return text(Rez.Strings.FieldActiveCalories); }
        if (field == FIELD_DISTANCE) { return text(Rez.Strings.FieldDistance); }
        if (field == FIELD_BATTERY) { return text(Rez.Strings.FieldBattery); }
        if (field == FIELD_STRESS) { return text(Rez.Strings.FieldStress); }
        if (field == FIELD_HEART) { return text(Rez.Strings.FieldHeartRate); }
        if (field == FIELD_BODY_BATTERY) { return text(Rez.Strings.FieldBodyBattery); }
        if (field == FIELD_SLEEP_SCORE) { return text(Rez.Strings.FieldSleepScore); }
        if (field == FIELD_SECONDS) { return text(Rez.Strings.FieldSeconds); }
        if (field == FIELD_DATE) { return text(Rez.Strings.FieldDate); }
        if (field == FIELD_WEEKDAY) { return text(Rez.Strings.FieldWeekday); }
        if (field == FIELD_TEMPERATURE) { return text(Rez.Strings.FieldTemperature); }
        if (field == FIELD_RECOVERY) { return text(Rez.Strings.FieldRecovery); }
        if (field == FIELD_ACTIVE_MINUTES) { return text(Rez.Strings.FieldActiveMinutes); }
        if (field == FIELD_STEP_GOAL) { return text(Rez.Strings.FieldStepGoal); }
        if (field == FIELD_SUNRISE) { return text(Rez.Strings.FieldSunrise); }
        if (field == FIELD_SUNSET) { return text(Rez.Strings.FieldSunset); }
        if (field == FIELD_RESTING_HR) { return text(Rez.Strings.FieldRestingHr); }
        if (field == FIELD_ELEVATION) { return text(Rez.Strings.FieldElevation); }
        if (field == FIELD_PRESSURE) { return text(Rez.Strings.FieldPressure); }
        if (field == FIELD_SPO2) { return text(Rez.Strings.FieldSpo2); }
        if (field == FIELD_TOTAL_CALORIES) { return text(Rez.Strings.FieldTotalCalories); }
        if (field == FIELD_RESTING_CALORIES) { return text(Rez.Strings.FieldRestingCalories); }
        if (field == FIELD_FLOORS_DESCENDED) { return text(Rez.Strings.FieldFloorsDescended); }
        if (field == FIELD_ACTIVE_MINUTES_WEEK) { return text(Rez.Strings.FieldActiveMinutesWeek); }
        if (field == FIELD_ACTIVE_MINUTES_WEEK_GOAL) { return text(Rez.Strings.FieldActiveMinutesWeekGoal); }
        if (field == FIELD_BATTERY_DAYS) { return text(Rez.Strings.FieldBatteryDays); }
        if (field == FIELD_HUMIDITY) { return text(Rez.Strings.FieldHumidity); }
        if (field == FIELD_VO2MAX_RUNNING) { return text(Rez.Strings.FieldVo2MaxRunning); }
        if (field == FIELD_SOLAR_INTENSITY) { return text(Rez.Strings.FieldSolarIntensity); }
        if (field == FIELD_MONTHLY_RUNNING_DISTANCE) { return text(Rez.Strings.FieldMonthlyRunningDistance); }
        if (field == FIELD_WEEK_NUMBER) { return text(Rez.Strings.FieldWeekNumber); }
        if (field == FIELD_NOTIFICATION_COUNT) { return text(Rez.Strings.FieldNotificationCount); }
        if (field == FIELD_HIGH_TEMPERATURE) { return text(Rez.Strings.FieldHighTemperature); }
        if (field == FIELD_LOW_TEMPERATURE) { return text(Rez.Strings.FieldLowTemperature); }
        if (field == FIELD_PRECIPITATION_CHANCE) { return text(Rez.Strings.FieldPrecipitationChance); }
        if (field == FIELD_HEART_RATE_ZONE) { return text(Rez.Strings.FieldHeartRateZone); }
        if (field == FIELD_AVG_RESTING_HR) { return text(Rez.Strings.FieldAverageRestingHr); }
        if (field == FIELD_ALARM_COUNT) { return text(Rez.Strings.FieldAlarmCount); }
        if (field == FIELD_RESPIRATION_RATE) { return text(Rez.Strings.FieldRespirationRate); }
        if (field == FIELD_NEXT_SUN_EVENT) { return text(Rez.Strings.FieldNextSunEvent); }
        if (field == FIELD_MONTHLY_CYCLING_DISTANCE) { return text(Rez.Strings.FieldMonthlyCyclingDistance); }
        if (field == FIELD_LOCATION_NAME) { return text(Rez.Strings.FieldLocationName); }
        if (field == FIELD_DAILY_RUNNING_DISTANCE) { return text(Rez.Strings.FieldDailyRunningDistance); }
        if (field == FIELD_WEEKLY_RUNNING_DISTANCE) { return text(Rez.Strings.FieldWeeklyRunningDistance); }
        if (field == FIELD_YEARLY_RUNNING_DISTANCE) { return text(Rez.Strings.FieldYearlyRunningDistance); }
        if (field == FIELD_DAILY_CYCLING_DISTANCE) { return text(Rez.Strings.FieldDailyCyclingDistance); }
        if (field == FIELD_WEEKLY_CYCLING_DISTANCE) { return text(Rez.Strings.FieldWeeklyCyclingDistance); }
        if (field == FIELD_YEARLY_CYCLING_DISTANCE) { return text(Rez.Strings.FieldYearlyCyclingDistance); }
        if (field == FIELD_METERS_CLIMBED) { return text(Rez.Strings.FieldMetersClimbed); }
        if (field == FIELD_VO2MAX_CYCLING) { return text(Rez.Strings.FieldVo2MaxCycling); }
        if (field == FIELD_SEA_LEVEL_PRESSURE) { return text(Rez.Strings.FieldSeaLevelPressure); }
        if (field == FIELD_TOTAL_DISTANCE_7_DAYS) { return text(Rez.Strings.FieldTotalDistance7Days); }
        if (field == FIELD_SENSOR_TEMPERATURE) { return text(Rez.Strings.FieldSensorTemperature); }
        if (field == FIELD_HOURS_TO_NEXT_SUN) { return text(Rez.Strings.FieldHoursToNextSun); }
        if (field == FIELD_ALT_TIMEZONE_1) { return text(Rez.Strings.FieldAltTimezone1); }
        if (field == FIELD_ALT_TIMEZONE_2) { return text(Rez.Strings.FieldAltTimezone2); }
        if (field == FIELD_UV_INDEX) { return text(Rez.Strings.FieldUvIndex); }
        if (field == FIELD_NEXT_CALENDAR_EVENT) { return text(Rez.Strings.FieldNextCalendarEvent); }
        if (field == FIELD_FEELS_LIKE) { return text(Rez.Strings.FieldFeelsLike); }
        return "";
    }

    private function fieldShortLabel(field as Lang.Number) as Lang.String {
        if (field == FIELD_STEPS) { return "STP"; }
        if (field == FIELD_FLOORS) { return "FLR"; }
        if (field == FIELD_CALORIES) { return "CAL"; }
        if (field == FIELD_DISTANCE) { return "DST"; }
        if (field == FIELD_BATTERY) { return "BAT"; }
        if (field == FIELD_STRESS) { return "STR"; }
        if (field == FIELD_HEART) { return "HR"; }
        if (field == FIELD_BODY_BATTERY) { return "BB"; }
        if (field == FIELD_SLEEP_SCORE) { return "SLEEP"; }
        if (field == FIELD_SECONDS) { return "SEC"; }
        if (field == FIELD_DATE) { return "DATE"; }
        if (field == FIELD_WEEKDAY) { return "DAY"; }
        if (field == FIELD_TEMPERATURE) { return "TEMP"; }
        if (field == FIELD_RECOVERY) { return "RECOV"; }
        if (field == FIELD_ACTIVE_MINUTES) { return "MIN"; }
        if (field == FIELD_STEP_GOAL) { return "STP%"; }
        if (field == FIELD_SUNRISE) { return "RISE"; }
        if (field == FIELD_SUNSET) { return "SET"; }
        if (field == FIELD_RESTING_HR) { return "RHR"; }
        if (field == FIELD_ELEVATION) { return "ELEV"; }
        if (field == FIELD_PRESSURE) { return "PRES"; }
        if (field == FIELD_SPO2) { return "PULSE OX"; }
        if (field == FIELD_LUNAR) { return "LUNAR"; }
        if (field == FIELD_TOTAL_CALORIES) { return "TCAL"; }
        if (field == FIELD_RESTING_CALORIES) { return "RCAL"; }
        if (field == FIELD_FLOORS_DESCENDED) { return "FLR DN"; }
        if (field == FIELD_ACTIVE_MINUTES_WEEK) { return "WMIN"; }
        if (field == FIELD_ACTIVE_MINUTES_WEEK_GOAL) { return "WGOAL"; }
        if (field == FIELD_BATTERY_DAYS) { return "BAT D"; }
        if (field == FIELD_HUMIDITY) { return "HUM"; }
        if (field == FIELD_VO2MAX_RUNNING) { return "VO2"; }
        if (field == FIELD_SOLAR_INTENSITY) { return "SOLAR"; }
        if (field == FIELD_MONTHLY_RUNNING_DISTANCE) { return "RUN MO"; }
        if (field == FIELD_WEEK_NUMBER) { return "WK #"; }
        if (field == FIELD_NOTIFICATION_COUNT) { return "NOTIF"; }
        if (field == FIELD_HIGH_TEMPERATURE) { return "HI TEMP"; }
        if (field == FIELD_LOW_TEMPERATURE) { return "LO TEMP"; }
        if (field == FIELD_PRECIPITATION_CHANCE) { return "PRECIP"; }
        if (field == FIELD_DAY_NIGHT) { return "D/N"; }
        if (field == FIELD_DAYLIGHT_REMAINING) { return "DAYL"; }
        if (field == FIELD_HEART_RATE_ZONE) { return "HR ZONE"; }
        if (field == FIELD_MOON_PHASE) { return "MOON"; }
        if (field == FIELD_SOLAR_TERM) { return "TERM"; }
        if (field == FIELD_AVG_RESTING_HR) { return "AVG RHR"; }
        if (field == FIELD_ALARM_COUNT) { return "ALARM"; }
        if (field == FIELD_RESPIRATION_RATE) { return "RESP"; }
        if (field == FIELD_WEATHER_CONDITION) { return "WX"; }
        if (field == FIELD_NEXT_SUN_EVENT) { return "SUN NXT"; }
        if (field == FIELD_MONTHLY_CYCLING_DISTANCE) { return "CYC MO"; }
        if (field == FIELD_LOCATION_NAME) { return "GPS"; }
        if (field == FIELD_DAILY_RUNNING_DISTANCE) { return "RUN D"; }
        if (field == FIELD_WEEKLY_RUNNING_DISTANCE) { return "RUN W"; }
        if (field == FIELD_YEARLY_RUNNING_DISTANCE) { return "RUN Y"; }
        if (field == FIELD_DAILY_CYCLING_DISTANCE) { return "CYC D"; }
        if (field == FIELD_WEEKLY_CYCLING_DISTANCE) { return "CYC W"; }
        if (field == FIELD_YEARLY_CYCLING_DISTANCE) { return "CYC Y"; }
        if (field == FIELD_METERS_CLIMBED) { return "CLIMB"; }
        if (field == FIELD_VO2MAX_CYCLING) { return "CYC VO2"; }
        if (field == FIELD_SEA_LEVEL_PRESSURE) { return "SLP"; }
        if (field == FIELD_TOTAL_DISTANCE_7_DAYS) { return "DST 7D"; }
        if (field == FIELD_SENSOR_TEMPERATURE) { return "S TEMP"; }
        if (field == FIELD_HOURS_TO_NEXT_SUN) { return "SUN HRS"; }
        if (field == FIELD_ALT_TIMEZONE_1) { return "ALT TZ 1"; }
        if (field == FIELD_ALT_TIMEZONE_2) { return "ALT TZ 2"; }
        if (field == FIELD_UV_INDEX) { return "UV"; }
        if (field == FIELD_NEXT_CALENDAR_EVENT) { return "NEXT CAL"; }
        if (field == FIELD_FEELS_LIKE) { return "FEELS"; }
        return "";
    }

    private function fieldValue(field as Lang.Number, battery as Lang.Number, activity, clock as System.ClockTime, date, conditions, now as Time.Moment) as Lang.String {
        // A small number of fields need ActivityMonitor.Info; if the system
        // has not made it available, return "--" instead of dereferencing null.
        if (activity == null) {
            if (field == FIELD_STEPS || field == FIELD_FLOORS || field == FIELD_DISTANCE ||
                field == FIELD_ACTIVE_MINUTES || field == FIELD_STEP_GOAL ||
                field == FIELD_CALORIES ||
                field == FIELD_TOTAL_CALORIES || field == FIELD_RESTING_CALORIES ||
                field == FIELD_FLOORS_DESCENDED || field == FIELD_ACTIVE_MINUTES_WEEK ||
                field == FIELD_ACTIVE_MINUTES_WEEK_GOAL || field == FIELD_RESPIRATION_RATE ||
                field == FIELD_METERS_CLIMBED) {
                return "--";
            }
        }
        var extended = extendedFieldValue(field, activity, date, conditions, now);
        if (extended != null) { return extended; }
        if (field == FIELD_STEPS) {
            return (!(activity has :steps) || activity.steps == null) ? "--" : activity.steps.format("%d");
        }
        if (field == FIELD_FLOORS) {
            return (!(activity has :floorsClimbed) || activity.floorsClimbed == null) ? "--" : activity.floorsClimbed.format("%d");
        }
        if (field == FIELD_METERS_CLIMBED) {
            return (!(activity has :metersClimbed) || activity.metersClimbed == null) ? "--" : activity.metersClimbed.format("%d");
        }
        if (field == FIELD_CALORIES) {
            var active = activeCalories(activity);
            return active == null ? "--" : active.format("%d");
        }
        if (field == FIELD_DISTANCE) {
            return (!(activity has :distance) || activity.distance == null) ? "--" : (activity.distance / 100000.0).format("%.1f");
        }
        if (field == FIELD_BATTERY) { return _batteryKnown ? battery.format("%d") + "%" : "--"; }
        if (field == FIELD_STRESS) {
            var stress = _cachedStress;
            return stress == null ? "--" : stress.toNumber().format("%d");
        }
        if (field == FIELD_HEART) {
            var hr = _cachedHeartRate;
            return hr == null ? "--" : hr.toNumber().format("%d");
        }
        if (field == FIELD_BODY_BATTERY) {
            var bb = _cachedBodyBattery;
            return bb == null ? "--" : bb.toNumber().format("%d") + "%";
        }
        if (field == FIELD_SLEEP_SCORE) {
            var score = _cachedSleepScore;
            return score == null ? "--" : score.toNumber().format("%d");
        }
        if (field == FIELD_SECONDS) { return clock.sec.format("%02d"); }
        if (field == FIELD_DATE) {
            return Lang.format(text(Rez.Strings.DatePattern), [date.month, date.day]);
        }
        if (field == FIELD_WEEKDAY) { return weekdayText(date.day_of_week); }
        if (field == FIELD_TEMPERATURE) {
            if (conditions == null || !(conditions has :temperature) || conditions.temperature == null) { return "--"; }
            return formatTemperature(conditions.temperature);
        }
        if (field == FIELD_RECOVERY) {
            var recovery = cachedRecoveryHours(now.value());
            if (recovery == null) { return "--"; }
            if (recovery < 9.9 && recovery != 0) { return recovery.format("%.1f") + "h"; }
            return recovery.format("%d") + "h";
        }
        if (field == FIELD_ACTIVE_MINUTES) {
            var mins = activeMinutesTotal(activity);
            return mins == null ? "--" : mins.format("%d");
        }
        if (field == FIELD_STEP_GOAL) {
            var goal = stepGoalPercent(activity);
            return goal == null ? "--" : goal.format("%d") + "%";
        }
        if (field == FIELD_SUNRISE) { return formatMoment(sunMoment(conditions, now, true)); }
        if (field == FIELD_SUNSET) { return formatMoment(sunMoment(conditions, now, false)); }
        if (field == FIELD_RESTING_HR) {
            var rest = restingHeartRate();
            return rest == null ? "--" : rest.format("%d");
        }
        if (field == FIELD_ELEVATION) {
            var elev = _cachedElevation;
            return elev == null ? "--" : elev.toNumber().format("%d") + "m";
        }
        if (field == FIELD_PRESSURE) {
            var press = _cachedPressure;
            return press == null ? "--" : (press.toFloat() / 100.0).format("%.0f");
        }
        if (field == FIELD_SEA_LEVEL_PRESSURE) {
            var seaPressure = _cachedSeaLevelPressure;
            return seaPressure == null ? "--" : (seaPressure.toFloat() / 100.0).format("%.0f");
        }
        if (field == FIELD_SPO2) {
            var spo2 = _cachedSpo2;
            return spo2 == null ? "--" : spo2.toNumber().format("%d") + "%";
        }
        if (field == FIELD_LUNAR) { return lunarDate(date, false); }
        if (field == FIELD_TOTAL_CALORIES) {
            return (!(activity has :calories) || activity.calories == null) ? "--" : activity.calories.format("%d");
        }
        if (field == FIELD_RESTING_CALORIES) {
            var resting = restingCalories(activity);
            return resting == null ? "--" : resting.format("%d");
        }
        if (field == FIELD_FLOORS_DESCENDED) {
            return (!(activity has :floorsDescended) || activity.floorsDescended == null) ? "--" : activity.floorsDescended.format("%d");
        }
        if (field == FIELD_ACTIVE_MINUTES_WEEK) {
            var weekMinutes = activeMinutesWeekTotal(activity);
            return weekMinutes == null ? "--" : weekMinutes.format("%d");
        }
        if (field == FIELD_ACTIVE_MINUTES_WEEK_GOAL) {
            var weekGoal = activeMinutesWeekGoalPercent(activity);
            return weekGoal == null ? "--" : weekGoal.format("%d") + "%";
        }
        if (field == FIELD_BATTERY_DAYS) {
            var days = batteryDaysRemaining();
            return days == null ? "--" : days.format("%.1f") + "d";
        }
        if (field == FIELD_HUMIDITY) {
            return conditions == null || !(conditions has :relativeHumidity) || conditions.relativeHumidity == null ? "--" : conditions.relativeHumidity.format("%d") + "%";
        }
        if (field == FIELD_VO2MAX_RUNNING) {
            var vo2max = cachedVo2maxRunning();
            return vo2max == null ? "--" : vo2max.format("%.0f");
        }
        if (field == FIELD_VO2MAX_CYCLING) {
            var cyclingVo2max = cachedVo2maxCycling();
            return cyclingVo2max == null ? "--" : cyclingVo2max.format("%.0f");
        }
        if (field == FIELD_SOLAR_INTENSITY) {
            var solar = cachedSolarIntensity();
            return solar == null ? "--" : solar.format("%d");
        }
        return "--";
    }

    private function weatherValue(kind as Lang.Number, conditions) as Lang.String {
        if (kind == WX_HIDDEN) { return ""; }
        if (conditions == null) { return "--"; }
        if (kind == WX_TEMP) {
            if (!(conditions has :temperature) || conditions.temperature == null) { return "--"; }
            return formatTemperature(conditions.temperature);
        }
        if (kind == WX_WIND) {
            if (!(conditions has :windSpeed) || conditions.windSpeed == null) { return "--"; }
            // m/s -> km/h
            return (conditions.windSpeed * 3.6).format("%.0f") + " km/h";
        }
        if (kind == WX_HIGH_LOW) {
            var high = !(conditions has :highTemperature) || conditions.highTemperature == null ? "--" : formatTemperatureValue(conditions.highTemperature);
            var low = !(conditions has :lowTemperature) || conditions.lowTemperature == null ? "--" : formatTemperatureValue(conditions.lowTemperature);
            return high + "~" + low + (high == "--" && low == "--" ? "" : temperatureSuffix());
        }
        if (kind == WX_CONDITION) {
            return !(conditions has :condition) ? "--" : weatherText(conditions.condition);
        }
        if (kind == WX_PRECIP) {
            if (!(conditions has :precipitationChance) || conditions.precipitationChance == null) { return "--"; }
            return conditions.precipitationChance.format("%d") + "%";
        }
        if (kind == WX_FEELS) {
            if (!(conditions has :feelsLikeTemperature) || conditions.feelsLikeTemperature == null) { return "--"; }
            return formatTemperature(conditions.feelsLikeTemperature);
        }
        return "--";
    }

    private function formatTemperature(value) as Lang.String {
        return formatTemperatureValue(value) + temperatureSuffix();
    }

    private function formatTemperatureValue(value) as Lang.String {
        var temperature = value.toFloat();
        if (numberProperty("TemperatureUnit", 0) == 1) {
            temperature = temperature * 9.0 / 5.0 + 32.0;
        }
        return temperature.format("%.0f");
    }

    // Legacy Garmin system fonts can render a missing-glyph box for the
    // degree sign. Their Celsius display remains unchanged; Fahrenheit uses
    // a plain F fallback so the selected unit is still unambiguous.
    private function temperatureSuffix() as Lang.String {
        if (numberProperty("TemperatureUnit", 0) == 1) {
            return Graphics has :getVectorFont ? "°F" : "F";
        }
        return Graphics has :getVectorFont ? "°" : "";
    }

    private function hasUsableWeather(conditions) as Lang.Boolean {
        return conditions != null && conditions has :temperature &&
            (conditions.temperature instanceof Lang.Number || conditions.temperature instanceof Lang.Float) &&
            conditions.temperature - conditions.temperature == 0;
    }

    private function updateLocationNameCache(conditions) as Void {
        if (conditions == null || !(conditions has :observationLocationName) ||
            conditions.observationLocationName == null || conditions.observationLocationName.length() == 0) {
            return;
        }
        var locationName = conditions.observationLocationName as Lang.String;
        if (_cachedLocationName.equals(locationName)) { return; }
        _cachedLocationName = locationName;
        try {
            Application.Storage.setValue("CNWatchFace2LocationName", _cachedLocationName);
        } catch (e) {
            // Keep the in-memory last known name when storage is unavailable.
        }
    }

    private function readLocationNameCache() as Lang.String {
        try {
            var stored = Application.Storage.getValue("CNWatchFace2LocationName") as Lang.String;
            return stored == null || stored.length() == 0 ? "--" : stored;
        } catch (e) {
            return "--";
        }
    }

    private function storeWeatherCache(conditions) as Void {
        if (!hasUsableWeather(conditions)) { return; }
        var data = {};
        data["updatedSeconds"] = _weatherUpdatedSeconds;
        data["temperature"] = conditions.temperature;
        if (conditions has :condition && conditions.condition != null) { data["condition"] = conditions.condition; }
        if (conditions has :highTemperature && conditions.highTemperature != null) { data["highTemperature"] = conditions.highTemperature; }
        if (conditions has :lowTemperature && conditions.lowTemperature != null) { data["lowTemperature"] = conditions.lowTemperature; }
        if (conditions has :precipitationChance && conditions.precipitationChance != null) { data["precipitationChance"] = conditions.precipitationChance; }
        if (conditions has :relativeHumidity && conditions.relativeHumidity != null) { data["relativeHumidity"] = conditions.relativeHumidity; }
        if (conditions has :feelsLikeTemperature && conditions.feelsLikeTemperature != null) { data["feelsLikeTemperature"] = conditions.feelsLikeTemperature; }
        if (conditions has :windBearing && conditions.windBearing != null) { data["windBearing"] = conditions.windBearing; }
        if (conditions has :windSpeed && conditions.windSpeed != null) { data["windSpeed"] = conditions.windSpeed; }
        if (conditions has :uvIndex && conditions.uvIndex != null) { data["uvIndex"] = conditions.uvIndex; }
        if (conditions has :observationLocationPosition && conditions.observationLocationPosition != null) {
            data["location"] = conditions.observationLocationPosition.toDegrees();
        }
        if (_cachedLocationName != "--") {
            data["observationLocationName"] = _cachedLocationName;
        }
        try {
            Application.Storage.setValue("CNWatchFace2Weather", data);
        } catch (e) {
            // Storage is an enhancement; the live cache remains usable.
        }
    }

    private function storedWeatherNumber(data as Lang.Dictionary, key as Lang.String, integer as Lang.Boolean) {
        var value = data.get(key);
        if (!(value instanceof Lang.Number || value instanceof Lang.Float) || value - value != 0) { return null; }
        return integer ? value.toNumber() : value.toFloat();
    }

    private function readWeatherCache() {
        try {
            var data = Application.Storage.getValue("CNWatchFace2Weather");
            if (!(data instanceof Lang.Dictionary)) { return null; }
            var temperature = storedWeatherNumber(data, "temperature", false);
            if (temperature == null) { return null; }
            var stored = new MAX2StoredWeather();
            stored.temperature = temperature;
            stored.condition = storedWeatherNumber(data, "condition", true);
            stored.highTemperature = storedWeatherNumber(data, "highTemperature", false);
            stored.lowTemperature = storedWeatherNumber(data, "lowTemperature", false);
            stored.precipitationChance = storedWeatherNumber(data, "precipitationChance", true);
            stored.relativeHumidity = storedWeatherNumber(data, "relativeHumidity", true);
            stored.feelsLikeTemperature = storedWeatherNumber(data, "feelsLikeTemperature", false);
            stored.windBearing = storedWeatherNumber(data, "windBearing", true);
            stored.windSpeed = storedWeatherNumber(data, "windSpeed", false);
            stored.uvIndex = storedWeatherNumber(data, "uvIndex", false);
            var location = data.get("location");
            if (location != null) {
                if (!(location instanceof Lang.Array) || location.size() < 2 ||
                    !isNumberInRange(location[0], -90, 90) || !isNumberInRange(location[1], -180, 180)) { return null; }
                stored.observationLocationPosition = new Position.Location({
                    :latitude => location[0], :longitude => location[1], :format => :degrees
                });
            }
            var name = data.get("observationLocationName");
            if (name instanceof Lang.String) { stored.observationLocationName = name; }
            var updated = data.get("updatedSeconds");
            _weatherUpdatedSeconds = updated instanceof Lang.Number && updated > 0 &&
                updated <= Time.now().value() ? updated : 0;
            return stored;
        } catch (e) {
            // Reject a malformed stored object without interrupting startup.
            return null;
        }
    }

    private function topWeatherText(pair as Lang.Number, conditions) as Lang.String {
        if (conditions == null) { return text(Rez.Strings.WeatherUnavailable); }
        if (pair == TOP_WEATHER_TEMP_CONDITION) {
            return weatherValue(WX_TEMP, conditions) + "  /  " + weatherValue(WX_CONDITION, conditions);
        }
        if (pair == TOP_WEATHER_TEMP_FEELS) {
            return weatherValue(WX_TEMP, conditions) + "  /  " + weatherValue(WX_FEELS, conditions);
        }
        if (pair == TOP_WEATHER_TEMP_WIND) {
            return weatherValue(WX_TEMP, conditions) + "  /  " + weatherValue(WX_WIND, conditions);
        }
        if (pair == TOP_WEATHER_TEMP_PRECIP) {
            return weatherValue(WX_TEMP, conditions) + "  /  " + weatherValue(WX_PRECIP, conditions);
        }
        if (pair == TOP_WEATHER_HIGH_LOW_CONDITION) {
            return weatherValue(WX_HIGH_LOW, conditions) + "  /  " + weatherValue(WX_CONDITION, conditions);
        }
        if (pair == TOP_WEATHER_HIGH_LOW_FEELS) {
            return weatherValue(WX_HIGH_LOW, conditions) + "  /  " + weatherValue(WX_FEELS, conditions);
        }
        if (pair == TOP_WEATHER_CONDITION_WIND) {
            return weatherValue(WX_CONDITION, conditions) + "  /  " + weatherValue(WX_WIND, conditions);
        }
        if (pair == TOP_WEATHER_CONDITION_PRECIP) {
            return weatherValue(WX_CONDITION, conditions) + "  /  " + weatherValue(WX_PRECIP, conditions);
        }
        if (pair == TOP_WEATHER_WIND_PRECIP) {
            return weatherValue(WX_WIND, conditions) + "  /  " + weatherValue(WX_PRECIP, conditions);
        }
        return weatherValue(WX_TEMP, conditions) + "  /  " + weatherValue(WX_HIGH_LOW, conditions);
    }

    private function progressData(metric as Lang.Number, activity, date) {
        var label = null;
        var current = null;
        var goal = null;
        if (metric == PROGRESS_RUN_DAY || metric == PROGRESS_RUN_WEEK || metric == PROGRESS_RUN_MONTH ||
            metric == PROGRESS_CYCLE_DAY || metric == PROGRESS_CYCLE_WEEK || metric == PROGRESS_CYCLE_MONTH) {
            var cycling = metric == PROGRESS_CYCLE_DAY || metric == PROGRESS_CYCLE_WEEK || metric == PROGRESS_CYCLE_MONTH;
            var period = metric == PROGRESS_RUN_DAY || metric == PROGRESS_CYCLE_DAY ? DISTANCE_PERIOD_DAY :
                         (metric == PROGRESS_RUN_WEEK || metric == PROGRESS_CYCLE_WEEK ? DISTANCE_PERIOD_WEEK : DISTANCE_PERIOD_MONTH);
            var distance = activityDistance(date, cycling, period);
            if (distance == null) { return null; }
            current = distance / 1000.0;
            if (metric == PROGRESS_RUN_DAY) { label = text(Rez.Strings.ProgressRunDay); goal = numberProperty("RunDayGoalKm", 0); }
            else if (metric == PROGRESS_RUN_WEEK) { label = text(Rez.Strings.ProgressRunWeek); goal = numberProperty("RunWeekGoalKm", 0); }
            else if (metric == PROGRESS_RUN_MONTH) { label = text(Rez.Strings.ProgressRunMonth); goal = numberProperty("RunMonthGoalKm", 0); }
            else if (metric == PROGRESS_CYCLE_DAY) { label = text(Rez.Strings.ProgressCycleDay); goal = numberProperty("CycleDayGoalKm", 0); }
            else if (metric == PROGRESS_CYCLE_WEEK) { label = text(Rez.Strings.ProgressCycleWeek); goal = numberProperty("CycleWeekGoalKm", 0); }
            else { label = text(Rez.Strings.ProgressCycleMonth); goal = numberProperty("CycleMonthGoalKm", 0); }
        } else if (metric == PROGRESS_STEPS) {
            if (activity == null || !(activity has :steps) || !(activity has :stepGoal) || activity.steps == null || activity.stepGoal == null) { return null; }
            label = text(Rez.Strings.ProgressSteps); current = activity.steps; goal = activity.stepGoal;
        } else if (metric == PROGRESS_FLOORS) {
            if (activity == null || !(activity has :floorsClimbed) || !(activity has :floorsClimbedGoal) || activity.floorsClimbed == null || activity.floorsClimbedGoal == null) { return null; }
            label = text(Rez.Strings.ProgressFloors); current = activity.floorsClimbed; goal = activity.floorsClimbedGoal;
        } else if (metric == PROGRESS_ACTIVE_MINUTES) {
            var minutes = activeMinutesWeekTotal(activity);
            if (activity == null || minutes == null || !(activity has :activeMinutesWeekGoal) || activity.activeMinutesWeekGoal == null) { return null; }
            label = text(Rez.Strings.ProgressActiveMinutes); current = minutes; goal = activity.activeMinutesWeekGoal;
        } else if (metric == PROGRESS_BODY_BATTERY) {
            var body = _cachedBodyBattery;
            if (body == null) { return null; }
            label = text(Rez.Strings.ProgressBodyBattery); current = body; goal = 100;
        } else {
            return null;
        }
        if (goal == null || goal <= 0) { return [label, 0.0]; }
        // Force floating-point division. ActivityMonitor values and goals are
        // integer Numbers, so plain division would turn e.g. 20/100 into 0.
        var percent = current.toFloat() / goal.toFloat();
        if (percent > 1.0) { percent = 1.0; }
        return [label, percent];
    }

    private function progressIconResource(metric as Lang.Number) as Lang.ResourceId {
        if (metric == PROGRESS_RUN_DAY || metric == PROGRESS_RUN_WEEK || metric == PROGRESS_RUN_MONTH ||
            metric == PROGRESS_STEPS) { return Rez.Drawables.MdiShoePrint; }
        if (metric == PROGRESS_CYCLE_DAY || metric == PROGRESS_CYCLE_WEEK || metric == PROGRESS_CYCLE_MONTH) {
            return Rez.Drawables.MdiBike;
        }
        if (metric == PROGRESS_FLOORS) { return Rez.Drawables.MdiStairs; }
        if (metric == PROGRESS_ACTIVE_MINUTES) { return Rez.Drawables.MdiTarget; }
        return Rez.Drawables.BodyBatteryIcon;
    }

    private function drawProgressArc(dc as Graphics.Dc, metric as Lang.Number, activity, date,
                                     left as Lang.Boolean, progressColor as Lang.Number,
                                     trackColor as Lang.Number, battery as Lang.Number) as Void {
        if (metric == PROGRESS_HIDDEN) { return; }
        var data = progressData(metric, activity, date);
        // Keep the selected goal visible while activity history is loading or
        // unavailable. Missing data means zero progress, not a missing arc.
        var completion = 0.0;
        if (data != null) {
            var progress = data as Lang.Array;
            completion = progress[1];
        }
        var trackPenWidth = scalePx(4);
        var progressPenWidth = scalePx(8);
        // Keep both strokes inside the round screen boundary. The progress
        // segment is intentionally twice as wide as the base arc.
        var screenRadius = ((_width < _height ? _width : _height) / 2).toNumber();
        var trackRadius = screenRadius - (trackPenWidth / 2).toNumber();
        var progressRadius = screenRadius - (progressPenWidth / 2).toNumber();
        var centerY = (_height / 2).toNumber();
        // Upper arc ends align with the 43- and 17-minute marks. Move the
        // icons about 10 degrees outward along the lower arc so they do not
        // share the centered battery row.
        var iconRadius = screenRadius - scalePx(24);
        var iconOffsetX = (iconRadius * 0.42).toNumber();
        var iconY = centerY + (iconRadius * 0.907).toNumber();
        // Reserve the actual battery text group plus the icon width and a
        // small gap. This keeps unusual battery values and small screens safe.
        var batteryValue = bottomBatteryValue(battery);
        var batteryGroupWidth = scalePx(18) + dc.getTextWidthInPixels(batteryValue, Graphics.FONT_XTINY);
        var iconHalfWidth = scalePx(10);
        var iconGap = scalePx(6);
        var safeIconOffset = ((batteryGroupWidth / 2).toNumber() + iconHalfWidth + iconGap).toNumber();
        if (iconOffsetX < safeIconOffset) { iconOffsetX = safeIconOffset; }
        // The track spans 63 degrees on both sides. A 100% completion must
        // therefore reach the far end of the selected base arc.
        var progressDegrees = (63 * completion).toNumber();
        // Keep a genuinely positive completion visible even below one pixel
        // of the 63-degree progress span.
        if (completion > 0 && progressDegrees < 1) { progressDegrees = 1; }
        dc.setPenWidth(trackPenWidth);
        dc.setColor(trackColor, Graphics.COLOR_TRANSPARENT);
        if (left) {
            dc.drawArc(_cx, centerY, trackRadius, Graphics.ARC_COUNTER_CLOCKWISE, 192, 255);
            if (progressDegrees > 0) {
                dc.setPenWidth(progressPenWidth);
                dc.setColor(progressColor, Graphics.COLOR_TRANSPARENT);
                // Start beside the battery and grow outward toward 43 minutes.
                dc.drawArc(_cx, centerY, progressRadius, Graphics.ARC_CLOCKWISE, 255, 255 - progressDegrees);
            }
            dc.setPenWidth(1);
            drawProgressGoalIcon(dc, metric, _cx - iconOffsetX, iconY, progressColor);
        } else {
            dc.drawArc(_cx, centerY, trackRadius, Graphics.ARC_COUNTER_CLOCKWISE, 285, 348);
            if (progressDegrees > 0) {
                dc.setPenWidth(progressPenWidth);
                dc.setColor(progressColor, Graphics.COLOR_TRANSPARENT);
                // Start beside the battery and grow outward toward 17 minutes.
                dc.drawArc(_cx, centerY, progressRadius, Graphics.ARC_COUNTER_CLOCKWISE, 285, 285 + progressDegrees);
            }
            dc.setPenWidth(1);
            drawProgressGoalIcon(dc, metric, _cx + iconOffsetX, iconY, progressColor);
        }
        dc.setPenWidth(1);
    }

    private function drawBottomBattery(dc as Graphics.Dc, cy as Lang.Number, warningColor as Lang.Number,
                                       normalColor as Lang.Number, battery as Lang.Number) as Void {
        var value = bottomBatteryValue(battery);
        var batteryColor = battery < 20 ? warningColor : normalColor;
        var valueWidth = dc.getTextWidthInPixels(value, Graphics.FONT_XTINY);
        var tipW = scalePx(2);
        var iconW = scalePx(12);
        var iconH = scalePx(8);
        var gap = scalePx(4);
        var groupWidth = iconW + tipW + gap + valueWidth;
        var iconX = _cx - (groupWidth / 2).toNumber();
        var iconY = cy;
        var valueX = iconX + iconW + tipW + gap;
        var pen = scalePx(1);
        if (pen < 2) { pen = 2; }
        dc.setColor(batteryColor, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(pen);
        dc.drawRectangle(iconX, iconY - (iconH / 2).toNumber(), iconW, iconH);
        dc.fillRectangle(iconX + iconW + scalePx(1), iconY - (iconH / 4).toNumber(), tipW, (iconH / 2).toNumber());
        dc.setPenWidth(1);
        var inset = scalePx(2);
        var maxFillW = iconW - inset * 2;
        var fillW = (maxFillW * battery / 100.0).toNumber();
        if (fillW < 0) { fillW = 0; }
        if (fillW > maxFillW) { fillW = maxFillW; }
        dc.setColor(batteryColor, Graphics.COLOR_TRANSPARENT);
        if (fillW > 0) {
            dc.fillRectangle(iconX + inset, iconY - (iconH / 2).toNumber() + inset, fillW, iconH - inset * 2);
        }
        dc.drawText(valueX, cy, Graphics.FONT_XTINY, value,
            Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function weatherText(condition) as Lang.String {
        if (condition == null) { return text(Rez.Strings.WEATHER_NA); }
        if (condition == 0) { return text(Rez.Strings.WEATHER_0); }
        if (condition == 1) { return text(Rez.Strings.WEATHER_1); }
        if (condition == 2) { return text(Rez.Strings.WEATHER_2); }
        if (condition == 3) { return text(Rez.Strings.WEATHER_3); }
        if (condition == 4) { return text(Rez.Strings.WEATHER_4); }
        if (condition == 5) { return text(Rez.Strings.WEATHER_5); }
        if (condition == 6) { return text(Rez.Strings.WEATHER_6); }
        if (condition == 7) { return text(Rez.Strings.WEATHER_7); }
        if (condition == 8) { return text(Rez.Strings.WEATHER_8); }
        if (condition == 9) { return text(Rez.Strings.WEATHER_9); }
        if (condition == 10) { return text(Rez.Strings.WEATHER_10); }
        if (condition == 11) { return text(Rez.Strings.WEATHER_11); }
        if (condition == 12) { return text(Rez.Strings.WEATHER_12); }
        if (condition == 13) { return text(Rez.Strings.WEATHER_13); }
        if (condition == 14) { return text(Rez.Strings.WEATHER_14); }
        if (condition == 15) { return text(Rez.Strings.WEATHER_15); }
        if (condition == 16) { return text(Rez.Strings.WEATHER_16); }
        if (condition == 17) { return text(Rez.Strings.WEATHER_17); }
        if (condition == 18) { return text(Rez.Strings.WEATHER_18); }
        if (condition == 19) { return text(Rez.Strings.WEATHER_19); }
        if (condition == 20) { return text(Rez.Strings.WEATHER_20); }
        if (condition == 21) { return text(Rez.Strings.WEATHER_21); }
        if (condition == 22) { return text(Rez.Strings.WEATHER_22); }
        if (condition == 23) { return text(Rez.Strings.WEATHER_23); }
        if (condition == 24) { return text(Rez.Strings.WEATHER_24); }
        if (condition == 25) { return text(Rez.Strings.WEATHER_25); }
        if (condition == 26) { return text(Rez.Strings.WEATHER_26); }
        if (condition == 27) { return text(Rez.Strings.WEATHER_27); }
        if (condition == 28) { return text(Rez.Strings.WEATHER_28); }
        if (condition == 29) { return text(Rez.Strings.WEATHER_29); }
        if (condition == 30) { return text(Rez.Strings.WEATHER_30); }
        if (condition == 31) { return text(Rez.Strings.WEATHER_31); }
        if (condition == 32) { return text(Rez.Strings.WEATHER_32); }
        if (condition == 33) { return text(Rez.Strings.WEATHER_33); }
        if (condition == 34) { return text(Rez.Strings.WEATHER_34); }
        if (condition == 35) { return text(Rez.Strings.WEATHER_35); }
        if (condition == 36) { return text(Rez.Strings.WEATHER_36); }
        if (condition == 37) { return text(Rez.Strings.WEATHER_37); }
        if (condition == 38) { return text(Rez.Strings.WEATHER_38); }
        if (condition == 39) { return text(Rez.Strings.WEATHER_39); }
        if (condition == 40) { return text(Rez.Strings.WEATHER_40); }
        if (condition == 41) { return text(Rez.Strings.WEATHER_41); }
        if (condition == 42) { return text(Rez.Strings.WEATHER_42); }
        if (condition == 43) { return text(Rez.Strings.WEATHER_43); }
        if (condition == 44) { return text(Rez.Strings.WEATHER_44); }
        if (condition == 45) { return text(Rez.Strings.WEATHER_45); }
        if (condition == 46) { return text(Rez.Strings.WEATHER_46); }
        if (condition == 47) { return text(Rez.Strings.WEATHER_47); }
        if (condition == 48) { return text(Rez.Strings.WEATHER_48); }
        if (condition == 49) { return text(Rez.Strings.WEATHER_49); }
        if (condition == 50) { return text(Rez.Strings.WEATHER_50); }
        if (condition == 51) { return text(Rez.Strings.WEATHER_51); }
        if (condition == 52) { return text(Rez.Strings.WEATHER_52); }
        if (condition == 53) { return text(Rez.Strings.WEATHER_53); }
        return text(Rez.Strings.WEATHER_53);
    }

    private function weekdayText(day as Lang.Number) as Lang.String {
        if (day == 1) { return text(Rez.Strings.WeekdaySunday); }
        if (day == 2) { return text(Rez.Strings.WeekdayMonday); }
        if (day == 3) { return text(Rez.Strings.WeekdayTuesday); }
        if (day == 4) { return text(Rez.Strings.WeekdayWednesday); }
        if (day == 5) { return text(Rez.Strings.WeekdayThursday); }
        if (day == 6) { return text(Rez.Strings.WeekdayFriday); }
        return text(Rez.Strings.WeekdaySaturday);
    }

    private function isChineseCalendar() as Lang.Boolean {
        return text(Rez.Strings.CalendarLanguage).equals("zh");
    }

    private function drawMdiIcon(dc as Graphics.Dc, resourceId as Lang.ResourceId, px as Lang.Number, py as Lang.Number, color as Lang.Number) as Lang.Boolean {
        try {
            var bitmap = WatchUi.loadResource(resourceId);
            var size = scalePx(16);
            if (Graphics has :AffineTransform) {
                var transform = new Graphics.AffineTransform();
                var scale = size / 24.0;
                transform.scale(scale, scale);
                dc.drawBitmap2(px - (size / 2).toNumber(), py - (size / 2).toNumber(),
                    bitmap, {:tintColor => color, :transform => transform});
            } else {
                dc.drawBitmap(px - (bitmap.getWidth() / 2).toNumber(),
                    py - (bitmap.getHeight() / 2).toNumber(), bitmap);
            }
            return true;
        } catch (e) {
            return false;
        }
    }

    private function drawProgressGoalIcon(dc as Graphics.Dc, metric as Lang.Number,
                                          px as Lang.Number, py as Lang.Number,
                                          color as Lang.Number) as Void {
        drawMdiIcon(dc, progressIconResource(metric), px, py, color);
    }

    // Monkey C supports a limited number of method arguments on older devices.
    // Keep the runtime data together so this helper remains portable.
    private function fittedContentFont(dc, value, maxWidth, preferredFont) {
        if (dc.getTextWidthInPixels(value, preferredFont) <= maxWidth) { return preferredFont; }
        if (dc.getTextWidthInPixels(value, Graphics.FONT_TINY) <= maxWidth) { return Graphics.FONT_TINY; }
        return Graphics.FONT_XTINY;
    }

    private function fitContentValue(dc, value, maxWidth, font) {
        if (dc.getTextWidthInPixels(value, font) <= maxWidth) { return value; }
        var suffix = "..";
        var end = value.length();
        while (end > 1) {
            var candidate = value.substring(0, end) + suffix;
            if (dc.getTextWidthInPixels(candidate, font) <= maxWidth) { return candidate; }
            end -= 1;
        }
        return value.substring(0, 1);
    }

    private function drawCompactField(dc as Graphics.Dc, field as Lang.Number, cx as Lang.Number, cy as Lang.Number, fieldTextColor as Lang.Number, fieldValueColor as Lang.Number, battery as Lang.Number, context as Lang.Array) as Void {
        if (field == FIELD_HIDDEN) { return; }
        var value = fieldValue(field, battery, context[0], context[1], context[2], context[3], context[4]);
        var maxWidth = x(0.25) - scalePx(8);
        var valueFont = fittedContentFont(dc, value, maxWidth, Graphics.FONT_SMALL);
        value = fitContentValue(dc, value, maxWidth, valueFont);
        dc.setColor(fieldValueColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, cy - scalePx(9), valueFont, value,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(fieldTextColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, cy + scalePx(13), Graphics.FONT_XTINY,
            fitContentValue(dc, fieldShortLabel(field), maxWidth, Graphics.FONT_XTINY),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }

    private function drawCompactTriple(dc as Graphics.Dc, first as Lang.Number, second as Lang.Number,
                                         third as Lang.Number, cy as Lang.Number, fieldTextColor as Lang.Number,
                                         fieldValueColor as Lang.Number, battery as Lang.Number, context as Lang.Array) as Void {
        drawCompactField(dc, first, x(0.25), cy, fieldTextColor, fieldValueColor, battery, context);
        drawCompactField(dc, second, _cx, cy, fieldTextColor, fieldValueColor, battery, context);
        drawCompactField(dc, third, x(0.75), cy, fieldTextColor, fieldValueColor, battery, context);
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        _width = dc.getWidth();
        _height = dc.getHeight();
        _cx = _width / 2;

        var clock = System.getClockTime();
        var now = Time.now();
        var date = Gregorian.info(now, Time.FORMAT_SHORT);
        var showAmPm = numberProperty("ShowAmPm", 1) == 1;
        var displayHour = clock.hour;
        if (showAmPm) {
            if (displayHour == 0) { displayHour = 12; }
            else if (displayHour > 12) { displayHour -= 12; }
        }

        // AOD only consumes values captured while the watch face was active.
        // Do this before any sensor, weather, or profile request.
        var amoledLowPower = _lowPower;
        if (isAmoledLayout() && (System has :getDisplayMode)) {
            amoledLowPower = amoledLowPower || System.getDisplayMode() == System.DISPLAY_MODE_LOW_POWER;
        }
        if (amoledLowPower && isAmoledLayout()) {
            drawAmoledAod(dc, clock, date, displayHour, numberProperty("LowPowerStyle", 1) == 1);
            return;
        }

        // Cache live data at the selected data interval. A one-second clock
        // repaint does not force sensor and weather reads unless the user
        // explicitly selected one-second data updates.
        var dataPeriod = numberProperty("UpdateFrequency", 60);
        if (dataPeriod < 1) { dataPeriod = 60; }
        var nowSeconds = now.value();
        var dataTick = (nowSeconds / dataPeriod).toNumber();
        var profileTick = (nowSeconds / PROFILE_CACHE_SECONDS).toNumber();
        var showSeconds = numberProperty("ShowSecondsActive", 0) == 1 && !_lowPower;
        var activityDay = (date.year * 13 + date.month) * 32 + date.day;
        var deferWakeRefresh = _wakeFramePending && _dataMinute >= 0 && _activityCacheDay == activityDay;
        _wakeFramePending = false;
        _deferActivityHistoryRefresh = deferWakeRefresh;
        _deferSunRefresh = deferWakeRefresh;
        if (!deferWakeRefresh) {
            var distanceFields = [fieldProperty("FieldLeft", FIELD_STEPS),
                fieldProperty("FieldCenter", FIELD_FLOORS), fieldProperty("FieldRight", FIELD_CALORIES)];
            var needsDistances = false;
            for (var d = 0; d < distanceFields.size(); d += 1) {
                var field = distanceFields[d];
                if (field == FIELD_MONTHLY_RUNNING_DISTANCE || field == FIELD_MONTHLY_CYCLING_DISTANCE ||
                    (field >= FIELD_DAILY_RUNNING_DISTANCE && field <= FIELD_YEARLY_CYCLING_DISTANCE) ||
                    field == FIELD_TOTAL_DISTANCE_7_DAYS) { needsDistances = true; }
            }
            var leftMetric = numberProperty("ProgressLeftMetric", PROGRESS_STEPS);
            var rightMetric = numberProperty("ProgressRightMetric", PROGRESS_CYCLE_DAY);
            if ((leftMetric >= PROGRESS_RUN_DAY && leftMetric <= PROGRESS_CYCLE_MONTH) ||
                (rightMetric >= PROGRESS_RUN_DAY && rightMetric <= PROGRESS_CYCLE_MONTH)) { needsDistances = true; }
            if (needsDistances) { updateActivityDistanceCache(date); }
        }
        // Every onUpdate callback owns a full-screen frame. Do not skip the
        // redraw when data is unchanged; some devices do not preserve the
        // previous frame buffer between system-requested updates.
        if (!deferWakeRefresh && dataTick != _dataMinute) {
            _dataMinute = dataTick;
            _heartRateCached = false;
            _bodyBatteryCached = false;
            _sleepScoreCached = false;
            _stressCached = false;
            _recoveryCached = false;
            _elevationCached = false;
            _pressureCached = false;
            _seaLevelPressureCached = false;
            _spo2Cached = false;
            _sensorTempCached = false;
            try {
                var latestStats = System.getSystemStats();
                if (latestStats != null) { _cachedStats = latestStats; }
            } catch (e) {
            }
            var stats = _cachedStats;
            if (stats != null && stats.battery != null) { _cachedBatteryPercent = stats.battery.toNumber(); _batteryKnown = true; }
            try {
                var latestActivityInfo = Activity.getActivityInfo();
                if (latestActivityInfo != null) { _cachedActivityInfo = latestActivityInfo; }
            } catch (e) {
            }
            if (_activityCacheDay != activityDay) {
                _activityCacheDay = activityDay;
                _cachedActivity = null;
            }
            try {
                var latestActivity = ActivityMonitor.getInfo();
                if (latestActivity != null) { _cachedActivity = latestActivity; }
            } catch (e) {
            }
            try {
                var latestDeviceSettings = System.getDeviceSettings();
                if (latestDeviceSettings != null) { _cachedDeviceSettings = latestDeviceSettings; }
            } catch (e) {
            }
            // Refresh sensor-backed values only on the configured data tick.
            // The draw path below consumes caches, so one-second clock frames
            // never call Complications, SensorHistory, or ActivityMonitor.
            refreshFieldData(fieldProperty("FieldLeft", FIELD_STEPS), _cachedActivity, date);
            refreshFieldData(fieldProperty("FieldCenter", FIELD_FLOORS), _cachedActivity, date);
            refreshFieldData(fieldProperty("FieldRight", FIELD_CALORIES), _cachedActivity, date);
            refreshProgressData(numberProperty("ProgressLeftMetric", PROGRESS_STEPS), date);
            refreshProgressData(numberProperty("ProgressRightMetric", PROGRESS_CYCLE_DAY), date);
            // Heart rate remains warm for the optional AOD heart-rate field.
            _cachedHeartRate = currentHeartRate();
            refreshOptionalFieldCache();
        }
        if (!_weatherStorageLoaded) {
            _weatherStorageLoaded = true;
            _cachedLocationName = readLocationNameCache();
            var storedWeather = readWeatherCache();
            if (hasUsableWeather(storedWeather)) {
                _cachedConditions = storedWeather;
                _weatherCacheTick = nowSeconds;
                updateLocationNameCache(storedWeather);
            }
        }
        if (!deferWakeRefresh && nowSeconds >= _weatherNextAttemptSeconds &&
            (Toybox has :Weather) && (Weather has :getCurrentConditions)) {
            _weatherNextAttemptSeconds = nowSeconds + WEATHER_RETRY_SECONDS;
            var latestConditions = null;
            try {
                latestConditions = Weather.getCurrentConditions();
            } catch (e) {
                // Keep the last known conditions and retry soon.
            }
            updateLocationNameCache(latestConditions);
            if (hasUsableWeather(latestConditions)) {
                // A Garmin weather object may exist while temperature is
                // temporarily null. Never replace a usable cache with that
                // incomplete result; retry it on the short retry interval.
                _cachedConditions = latestConditions;
                _weatherCacheTick = nowSeconds;
                _weatherUpdatedSeconds = nowSeconds;
                _weatherNextAttemptSeconds = nowSeconds + WEATHER_CACHE_SECONDS;
                storeWeatherCache(latestConditions);
            }
        }
        if (!deferWakeRefresh && profileTick != _profileCacheTick) {
            _profileCacheTick = profileTick;
            try {
                var latestProfile = UserProfile.getProfile();
                if (latestProfile != null) { _cachedProfile = latestProfile; }
            } catch (e) {
            }
            try {
                if (UserProfile has :getHeartRateZones) {
                    var latestZones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
                    if (latestZones != null && latestZones.size() >= 6) { _cachedHeartRateZones = latestZones; }
                }
            } catch (e) {
            }
        }
        var batteryPercent = _cachedBatteryPercent;
        var activity = _cachedActivity;
        var conditions = _cachedConditions;

        var timeColor = displayColor(numberProperty("TimeColor", COLOR_WARM_WHITE));
        var dateColor = displayColor(numberProperty("DateColor", COLOR_SOFT_GRAY));
        var secondsColor = displayColor(numberProperty("SecondsColor", COLOR_CORAL));
        var amPmColor = displayColor(numberProperty("AmPmColor", COLOR_CORAL));
        var fieldTextColor = displayColor(numberProperty("FieldTextColor", COLOR_SOFT_GRAY));
        var fieldValueColor = displayColor(numberProperty("FieldValueColor", COLOR_WARM_WHITE));
        var sky = displayLandscapeColor(numberProperty("SkyColor", COLOR_SUNSET), 0);
        var far = displayLandscapeColor(numberProperty("MountainFarColor", COLOR_FAR_BLUE), 1);
        var mid = displayLandscapeColor(numberProperty("MountainMidColor", COLOR_MID_SLATE), 2);
        var near = displayLandscapeColor(numberProperty("MountainNearColor", COLOR_NEAR_INK), 3);
        // Use direct light tones for MIP's limited palette and keep the arcs
        // visibly separated from the mountain silhouettes on AMOLED as well.
        var progressColor = displayColor(numberProperty("ProgressColor", COLOR_ORANGE));
        var leftColor = numberProperty("ProgressLeftColor", -1);
        var rightColor = numberProperty("ProgressRightColor", -1);
        var progressLeftColor = leftColor < 0 ? progressColor : displayColor(leftColor);
        var progressRightColor = rightColor < 0 ? progressColor : displayColor(rightColor);
        var progressTrackColor = displayColor(numberProperty("ProgressTrackColor", 0x7D919D));
        var batteryColor = displayColor(numberProperty("BatteryColor", COLOR_SOFT_GRAY));
        var batteryWarningColor = displayColor(numberProperty("BatteryWarningColor", 0xFF5566));
        var weatherColor = numberProperty("TopWeatherColor", -1);
        var topWeatherColor = weatherColor < 0 ? dateColor : displayColor(weatherColor);
        // This setting owns the complete clock format: 12-hour with AM/PM,
        // or 24-hour without it. Do not inherit the device's clock setting.
        // onEnterSleep() is the watch-face indication that the wrist is down
        // or the device is in AOD/low-power state. Never draw stale seconds
        // there, regardless of the selected low-power layout.
        dc.setColor(COLOR_BLACK, COLOR_BLACK);
        dc.clear();

        // AMOLED burn-in mitigation: when the display is OLED, nudge the
        // time, date and bottom-field blocks by ±1 px on a slow
        // cycle (10 minutes per shift).  The user won't notice the change
        // but no single pixel stays bright for the full day.  MIP devices
        // are unaffected because the offset is always 0.
        var amoledJitterX = 0;
        var amoledJitterY = 0;
        if (isAmoledLayout() && !_lowPower) {
            amoledJitterX = ((((clock.min + clock.hour * 60) / 10).toNumber()) % 3) - 1;
            amoledJitterY = ((((clock.min + clock.hour * 60) / 30).toNumber()) % 3) - 1;
        }

        drawMountains(dc, sky, far, mid, near);

        var topCustomText = stringProperty("TopCustomText", "");
        if (topCustomText.length() > 0) {
            dc.setColor(dateColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(_cx, y(0.08), Graphics.FONT_XTINY, topCustomText,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        var fieldContext = [activity, clock, date, conditions, now];

        if (numberProperty("ShowWeatherRow", 1) == 1) {
            // Top weather summary
            var topY = _profileTopFieldY;
    
            var topWeather = topWeatherText(numberProperty("TopWeatherPair", TOP_WEATHER_TEMP_HIGH_LOW), conditions);
            var topWidth = x(0.76);
            var topFont = fittedContentFont(dc, topWeather, topWidth, Graphics.FONT_TINY);
            topWeather = fitContentValue(dc, topWeather, topWidth, topFont);
            dc.setColor(topWeatherColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(_cx, topY, topFont, topWeather,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        // Time, seconds and AM/PM form one measured component. Reserve the
        // configured side slot even while seconds are suppressed in sleep, so
        // waking the watch cannot make the main time jump horizontally.
        var timeText = displayHour.format("%02d") + ":" + clock.min.format("%02d");
        var secondsText = clock.sec.format("%02d");
        var amPmText = clock.hour < 12 ? "AM" : "PM";
        var reserveSeconds = numberProperty("ShowSecondsActive", 0) == 1;
        var reserveSide = reserveSeconds || showAmPm;
        var worstTimeText = showAmPm ? "12:59" : "23:59";
        var sideLineCount = (reserveSeconds ? 1 : 0) + (showAmPm ? 1 : 0);
        var timeFont = fittedTimeFont(dc, worstTimeText, reserveSide);
        var timeSlotWidth = dc.getTextWidthInPixels(worstTimeText, timeFont);
        var sideWidth = dc.getTextWidthInPixels("59", _profileSideFont);
        var amPmWidth = dc.getTextWidthInPixels("PM", _profileSideFont);
        if (amPmWidth > sideWidth) { sideWidth = amPmWidth; }
        var sideGap = _profileSideGap;
        if (_profileExpandVectorTime && _timeVectorFont != null) {
            sideGap += _profileVectorSideGap;
        }
        var componentWidth = timeSlotWidth;
        if (reserveSide) { componentWidth += sideGap + sideWidth; }
        var componentLeft = _cx - (componentWidth / 2).toNumber() + amoledJitterX;
        var clockCenterX = componentLeft + (timeSlotWidth / 2).toNumber();
      var vectorTime = _profileExpandVectorTime && _timeVectorFont != null;
      var timeY = _profileTimeCenterY + (vectorTime ? scalePx(7) : 0) + amoledJitterY;
        dc.setColor(timeColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(clockCenterX, timeY, timeFont, timeText,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        var sideFontH = dc.getFontHeight(_profileSideFont);
        var sideBlockH = sideLineCount == 0 ? 0 :
                         (sideLineCount > 1 ? sideFontH * 2 + _profileSideLineGap : sideFontH);
        var blockCenterX = componentLeft + timeSlotWidth + sideGap +
                   (sideWidth / 2).toNumber() -
                   (vectorTime ? scalePx(7) : 0);
        var firstSideY = timeY;
        var secondSideY = timeY;
        if (sideLineCount > 1) {
            firstSideY = timeY - (sideBlockH / 2).toNumber() + (sideFontH / 2).toNumber();
            secondSideY = firstSideY + sideFontH + _profileSideLineGap;
        }
        if (showSeconds) {
            dc.setColor(secondsColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(blockCenterX, firstSideY, _profileSideFont, secondsText,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        if (numberProperty("ShowCalendarRow", 1) == 1) {
            // The calendar owns the center row. Using the number font's full line
            // height here would include device-specific internal leading and push
            // the date and every following row too far down.
            var showDate = numberProperty("ShowDate", 1) == 1;
            var showWeekday = numberProperty("ShowWeekday", 1) == 1;
            var showLunar = numberProperty("ShowLunar", 0) == 1;
            var showSolarTerm = numberProperty("ShowSolarTerm", 0) == 1;
            var dateText = showDate ? Lang.format(text(Rez.Strings.DatePattern), [date.month, date.day]) : "";
            var weekday = showWeekday ? weekdayText(date.day_of_week) : "";
            var chineseCalendar = isChineseCalendar();
            var vectorCalendar = Graphics has :getVectorFont;
            var lunarText = showLunar ? lunarDate(date, chineseCalendar && vectorCalendar) : "";
            var solarText = showSolarTerm ? solarTermText(date) : "";
            var calendarItemCount = (showDate ? 1 : 0) + (showWeekday ? 1 : 0) +
                                    (showLunar ? 1 : 0) + (showSolarTerm ? 1 : 0);
            var calendarItems = [];
            if (showDate) { calendarItems.add(dateText); }
            if (showWeekday) { calendarItems.add(weekday); }
            if (showLunar) { calendarItems.add(lunarText); }
            if (showSolarTerm) { calendarItems.add(solarText); }
            var calendarOptions = (showDate ? 1 : 0) | (showWeekday ? 2 : 0) |
                                  (showLunar ? 4 : 0) | (showSolarTerm ? 8 : 0);
            var calendarCacheKey = (((date.year * 13 + date.month) * 32 + date.day) * 16) + calendarOptions;
            var sharedCalendarFont = vectorCalendar ?
                fittedCalendarFont(dc, calendarItems, calendarItemCount, calendarCacheKey) : null;
            if (sharedCalendarFont == null && showLunar && vectorCalendar) {
                lunarText = lunarDate(date, false);
                calendarItems = [];
                if (showDate) { calendarItems.add(dateText); }
                if (showWeekday) { calendarItems.add(weekday); }
                calendarItems.add(lunarText);
                if (showSolarTerm) { calendarItems.add(solarText); }
            }
            var calendarFont = sharedCalendarFont;
            if (calendarFont == null) {
                calendarFont = vectorCalendar ? Graphics.FONT_XTINY :
                               fittedLegacyCalendarFont(dc, calendarItems, calendarItemCount);
            }
            var dateY = _profileCalendarCenterY +
                        (vectorCalendar ? _profileVectorCalendarOffset : 0) + amoledJitterY;
            var dateWidth = showDate ? dc.getTextWidthInPixels(dateText, calendarFont) : 0;
            var weekdayWidth = showWeekday ? dc.getTextWidthInPixels(weekday, calendarFont) : 0;
            var lunarWidth = showLunar ? dc.getTextWidthInPixels(lunarText, calendarFont) : 0;
            var solarWidth = showSolarTerm ? dc.getTextWidthInPixels(solarText, calendarFont) : 0;
            dc.setColor(dateColor, Graphics.COLOR_TRANSPARENT);
            // Every layout stays centered; the setting only controls the space
            // between enabled calendar items.
            var calendarLayout = numberProperty("CalendarLayout", 2);
            var calendarGap = scalePx(8); // centered standard
            if (calendarLayout == 1) { calendarGap = scalePx(2); } // compact
            else if (calendarLayout == 2) { calendarGap = scalePx(18); } // wide
            var calendarContentWidth = dateWidth + weekdayWidth + lunarWidth + solarWidth;
            var calendarWidth = calendarContentWidth;
            if (calendarItemCount > 1) {
                var calendarAvailableWidth = roundContentWidthAt(dateY, calendarInset(calendarItemCount));
                var fittedGap = ((calendarAvailableWidth - calendarContentWidth) / (calendarItemCount - 1)).toNumber();
                if (calendarGap > fittedGap) { calendarGap = fittedGap > 0 ? fittedGap : 0; }
                calendarWidth = calendarContentWidth + calendarGap * (calendarItemCount - 1);
            }
            var calendarX = _cx - (calendarWidth / 2).toNumber();
            if (showDate) {
                dc.drawText(calendarX, dateY, calendarFont, dateText,
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
                calendarX += dateWidth + calendarGap;
            }
            if (showWeekday) {
                dc.drawText(calendarX, dateY, calendarFont, weekday,
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
                calendarX += weekdayWidth + calendarGap;
            }
            if (showLunar) {
                dc.drawText(calendarX, dateY, calendarFont, lunarText,
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
                calendarX += lunarWidth + calendarGap;
            }
            if (showSolarTerm) {
                dc.drawText(calendarX, dateY, calendarFont, solarText,
                    Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            }
        }

        if (showAmPm) {
            dc.setColor(amPmColor, Graphics.COLOR_TRANSPARENT);
            dc.drawText(blockCenterX, reserveSeconds ? secondSideY : firstSideY, _profileSideFont, amPmText,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        // Two independent side arcs hug the lower dial. Each arc shows only
        // its target icon and completion, leaving the center visually quiet.
        drawProgressArc(dc, numberProperty("ProgressLeftMetric", PROGRESS_STEPS), activity, date,
            true, progressLeftColor, progressTrackColor, batteryPercent);
        drawProgressArc(dc, numberProperty("ProgressRightMetric", PROGRESS_CYCLE_DAY), activity, date,
            false, progressRightColor, progressTrackColor, batteryPercent);
        var fieldRowY = y(0.69) + amoledJitterY;
        drawCompactTriple(dc, fieldProperty("FieldLeft", FIELD_STEPS),
            fieldProperty("FieldCenter", FIELD_FLOORS),
            fieldProperty("FieldRight", FIELD_CALORIES), fieldRowY,
            fieldTextColor, fieldValueColor, batteryPercent, fieldContext);
        drawBottomBattery(dc, y(0.90) + amoledJitterY, batteryWarningColor, batteryColor, batteryPercent);
    }
}

class MAX2StoredWeather {
    public var observationLocationPosition as Position.Location or Null;
    public var observationLocationName as Lang.String or Null;
    public var precipitationChance as Lang.Number or Null;
    public var temperature as Lang.Numeric or Null;
    public var windBearing as Lang.Number or Null;
    public var windSpeed as Lang.Float or Null;
    public var highTemperature as Lang.Numeric or Null;
    public var lowTemperature as Lang.Numeric or Null;
    public var feelsLikeTemperature as Lang.Float or Null;
    public var relativeHumidity as Lang.Number or Null;
    public var condition as Lang.Number or Null;
    public var uvIndex as Lang.Float or Null;
}
