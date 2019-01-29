using Toybox.WatchUi;
using Toybox.UserProfile;

class TrainingVolumeView extends WatchUi.SimpleDataField {

    var trainingVolume;  // 当前活动所累积的 “训练指数”
    var lastUpdateTime;  // 上次更新 “训练指数” 的时间

    var maxHeartRate;  // 用户的最大心率（需要用户在 Garmin Connect 中设置）
    var restingHeartRate;  // 用户的静息心率（需要用户在 Garmin Connect 中设置）

    const HR_ZONE1_LOW = 59;  // 心率1区的下限（值对应的是 HRR%）
    const HR_ZONE5_HIGH = 100;  // 心率5区的上限（值对应的是 HRR%）

    const VOLUMES_PER_MINUTE = {  // HRR% 与 每分钟训练指数 的对应关系
        // 心率1区
        59 => 0.100, 60 => 0.110, 61 => 0.122, 62 => 0.135, 63 => 0.150, 64 => 0.167, 65 => 0.183, 66 => 0.200,
        67 => 0.217, 68 => 0.233, 69 => 0.250, 70 => 0.267, 71 => 0.283, 72 => 0.300, 73 => 0.317, 74 => 0.333,
        // 心率2区
        75 => 0.350, 76 => 0.367, 77 => 0.392, 78 => 0.417, 79 => 0.442, 80 => 0.467, 81 => 0.492, 82 => 0.517,
        83 => 0.550, 84 => 0.583,
        // 心率3区
        85 => 0.600, 86 => 0.617, 87 => 0.650, 88 => 0.683,
        // 心率4区
        89 => 0.700, 90 => 0.723, 91 => 0.763, 92 => 0.800, 93 => 0.840, 94 => 0.883, 95 => 0.900,
        // 心率5区
        96 => 0.917, 97 => 0.940, 98 => 0.960, 99 => 0.983, 100 => 1.000
    };

    // 数据栏初始化
    function initialize() {
        SimpleDataField.initialize();

        label = loadResource(Rez.Strings.Label);
        initStatisticalData();
        initHeartRateData();
    }

    // 初始化统计数据
    function initStatisticalData() {
        trainingVolume = 0.0;
        lastUpdateTime = 0;
    }

    // 初始化心率数据（获取用户的最大心率、静息心率）
    function initHeartRateData() {
        var profile = UserProfile.getProfile();
        restingHeartRate = profile.restingHeartRate;
        var hrZones = profile.getHeartRateZones(profile.getCurrentSport());
        maxHeartRate = hrZones[hrZones.size() - 1];
    }

    // 计算 HRR%
    function calcHrrPercent(heartRate) {
        var hrrPercent = (heartRate - restingHeartRate) * 100.0 / (maxHeartRate - restingHeartRate);
        return Math.round(hrrPercent).toNumber();
    }

    // 计算每分钟的训练指数
    function calcTrainingVolumePerMinute(hrrPercent) {
        if (hrrPercent <= 0) {
            return 0.0;
        } else if (hrrPercent < HR_ZONE1_LOW) {
            return VOLUMES_PER_MINUTE[HR_ZONE1_LOW] * hrrPercent / HR_ZONE1_LOW;
        } else if (hrrPercent <= HR_ZONE5_HIGH) {
            return VOLUMES_PER_MINUTE[hrrPercent];
        } else {
            return VOLUMES_PER_MINUTE[HR_ZONE5_HIGH] * hrrPercent / HR_ZONE5_HIGH;
        }
    }

    // 更新数据栏的值
    function compute(info) {
        var currentTime = info.timerTime;
        var heartRate = info.currentHeartRate;

        if (currentTime < lastUpdateTime) {  // 重新开始了一个活动
            trainingVolume = 0.0;
            lastUpdateTime = currentTime;
        } else {  // 当前活动
            var volume = 0.0;
            if (heartRate != null) {
                var hrrPercent = calcHrrPercent(heartRate);
                var volumePerMinute = calcTrainingVolumePerMinute(hrrPercent);
                volume = volumePerMinute * (currentTime - lastUpdateTime) / (60 * 1000);
            }

            trainingVolume += volume;
            lastUpdateTime = currentTime;
        }

        return trainingVolume;
    }
}