使用非 GUI 模式，即命令行模式运行 JMeter 测试脚本能够大大缩减所需要的系统资源。使用命令
**jmeter -n -t <testplan filename> -l <listener filename>**
(比如 jmeter -n -t testplan.jmx -l listener.jtl)

执行结果可以使用 GUI 模式下的聚合报告查看，比如你想要看 addCustomerScript201411060954.jtl 的报告，可以打开 JMeter GUI 界面 -> 测试计划 -> 添加线程组 -> 添加聚合报告 -> 点击"所有数据写入一个文件"下的 "浏览..." 按钮找到你刚生成的 jtl 文件就可以对执行结果进行直观分析了。