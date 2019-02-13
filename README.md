# Training Volume

Training Volume，中文翻译为 [训练指数][jianshu-trainingvolume]，是跑步训练量的一种表示方式。

本项目开发了一个 Garmin Connect IQ 数据栏（Data Field），方便跑者在训练中实时查看当前活动所累积的训练指数。该数据栏可用于 Garmin Forerunner、Feinix 系列的运动腕表。



## 使用方法

1. 在 Garmin Connect IQ 市场中下载 TrainingVolume 数据栏（中文名为：训练指数），并将其安装在手表中。
2. 将手表的一个数据域设置为 TrainingVolume（中文名为：训练指数）。
3. 开始一个跑步活动，TrainingVolume 数据栏将显示当前活动所累积的训练指数。



⚠️ 使用之前，请先在 Garmin Connect 中正确设置 **最大心率**、**静息心率**，并已同步到手表中。



## 功能说明

* 仅显示 **当前活动** 所累积的训练指数
* 仅计算活动 **进行** 期间的训练指数（不计算 **暂停**、**停止** 期间的训练指数）



## 注意事项

这个数据栏中显示的训练指数，与 Running Quotient（以下简称 RQ）中的结果可能不完全相同。原因是：

* RQ 的算法会综合考虑 **心率**、**配速区间**
* 本项目的算法只考虑 **心率**（因为无法获得 RQ 中的配速区间）



有可能导致以下结果：

* 在进行 E、M、T 等训练时，二者的计算结果基本相同。
* 在进行 A、I、R 等训练时，RQ 的训练指数更高一些。



[jianshu-trainingvolume]: https://www.jianshu.com/p/57e8a465198b
