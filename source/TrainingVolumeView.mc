using Toybox.WatchUi;
using Toybox.UserProfile;

class TrainingVolumeView extends WatchUi.SimpleDataField {

	// 全局变量
	var trainingVolume;
	var trainingVolumesPerMinute;
	var restingHeartRate;
	var maxHeartRate;
	var lastUpdateTime;
	var heartRateZoneStart;
	var heartRateZoneEnd;

	// 初始化
    function initialize() {
        SimpleDataField.initialize();

        label = loadResource(Rez.Strings.Label);
        trainingVolume = 0.0;
        trainingVolumesPerMinute = {
        	59 => 0.100, 60 => 0.110, 61 => 0.122, 62 => 0.135, 63 => 0.150, 64 => 0.167, 65 => 0.183, 66 => 0.200, 67 => 0.217, 68 => 0.233, 69 => 0.250, 70 => 0.267, 71 => 0.283, 72 => 0.300, 73 => 0.317, 74 => 0.333,
        	75 => 0.350, 76 => 0.367, 77 => 0.392, 78 => 0.417, 79 => 0.442, 80 => 0.467, 81 => 0.492, 82 => 0.517, 83 => 0.550, 84 => 0.583,
        	85 => 0.600, 86 => 0.617, 87 => 0.650, 88 => 0.683,
        	89 => 0.700, 90 => 0.723, 91 => 0.763, 92 => 0.800, 93 => 0.840, 94 => 0.883, 95 => 0.900,
        	96 => 0.917, 97 => 0.940, 98 => 0.960, 99 => 0.983, 100 => 1.000
        };

        var profile = UserProfile.getProfile();
        restingHeartRate = profile.restingHeartRate;
        var heartRateZones = profile.getHeartRateZones(profile.getCurrentSport());
        maxHeartRate = heartRateZones[heartRateZones.size() - 1];

        heartRateZoneStart = 59;
        heartRateZoneEnd = 100;
        lastUpdateTime = 0;
    }

    // 根据心率、持续时间，计算这段时间的训练指数
    //
    // 参数：
    //		heartRate: 心率，单位：bpm（beats per minute）
    //		duration: 该心率的持续时间，单位：毫秒
    // 返回值：
    //		该心率在这段持续时间内所对应的训练指数
    function computeTrainingVolume(heartRate, duration) {
    	var hrrPercent = computeHrrPercent(heartRate);
    	var trainingVolumePerMinute = 0.0;
    	if (hrrPercent < heartRateZoneStart) {
    		trainingVolumePerMinute = trainingVolumesPerMinute[heartRateZoneStart] * hrrPercent / heartRateZoneStart;
    	} else if (hrrPercent > heartRateZoneEnd) {
    		trainingVolumePerMinute = trainingVolumesPerMinute[heartRateZoneEnd] * hrrPercent / heartRateZoneEnd;
    	} else {
    		trainingVolumePerMinute = trainingVolumesPerMinute.get(hrrPercent);
    	}

		return trainingVolumePerMinute * duration / (60 * 1000);
    }

    // 计算心率对应的储备心率%（HRR：Heart Rate Reserve）
    //
    // 参数：
    //		heartRate: 心率，单位：bpm（beats per minute）
    // 返回值：
    //		该心率对应的储备心率%
    function computeHrrPercent(heartRate) {
    	var hrrPercent = (heartRate - restingHeartRate) * 100.0 / (maxHeartRate - restingHeartRate);
    	return Math.round(hrrPercent).toNumber();
    }

    // 计算要显示的数值（即该数据栏中显示的数值）
    //
    // 参数：
    //		info: (Activity.Info) 活动数据的信息
    // 注意：
    //		compute() 和 onUpdate() 是异步的，因此，compute 并不一定总是在 onUpdate() 之前被调用。
    // 返回值：
    //		返回值将被显示在这个数据栏中 
    function compute(info) {
    	if (info has :currentHeartRate && info.currentHeartRate != null) {
    		var hr = info.currentHeartRate;
    		var currentTime = info.timerTime;
    		trainingVolume += computeTrainingVolume(hr, currentTime - lastUpdateTime);
    		lastUpdateTime = currentTime;
    	}

        return trainingVolume;
    }
}