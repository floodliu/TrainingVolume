using Toybox.WatchUi;

class TrainingVolumeView extends WatchUi.SimpleDataField {

	// 全局变量
	var trainingVolume;

	// 初始化
    function initialize() {
        SimpleDataField.initialize();

        label = loadResource(Rez.Strings.Label);
        trainingVolume = 0.0;
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
        return trainingVolume;
    }

}