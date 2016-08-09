# MSKUFramework

https://github.com/was0107/MSKUFramework

##需求
*  模仿淘宝SKU的选择页面，实现商品的SKU选择；

##效果展示
*	目前SKU选项，由`UIButton`生成，具体效果请参阅下图<br>
<img src="https://raw.githubusercontent.com/was0107/MSKUFramework/master/images/sku.gif" width="50%" >

##分析
*	商品图片、价格、库存、当前选择项、能根据SKU的选中项进行更改；
*	商品图片、价格、库存、当前选择项、SKU选择项能跟随键盘作动画处理；
*	购买数量能根据当前SKU的库存，进行动态设置，且能对进行友好输入；

##实现
*	`NumberChooseControl`控件的自定义，主要对购买数量进行逻辑处理
*	`SKUControl`根据商品的属性进行动态设置，需要提供接口供外部进行动态更改；鉴于SKU的选中项需求的不确定性，故开放给业务方，进行数据填充

##使用
*	1、此项目依赖SDK最低版本为7.0；
*	2、在工程中引入MSKUFramework.framework即可使用；





