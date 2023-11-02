import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fn_ui_kit/fn_ui_kit.dart';

/*
* @description:     步骤条
* param:
* @return:
* @author:          novice.cai
* @time:            2023/11/1 11:58
*/
class FNUISteps extends StatelessWidget {
  const FNUISteps({
    Key? key,
    this.active = 0,
    this.direction = Axis.horizontal,
    this.activeColor,
    this.inactiveColor,
    this.activeIconName,
    this.activeIconUrl,
    this.inactiveIconName,
    this.inactiveIconUrl,
    this.finishIconName,
    this.finishIconUrl,
    this.onClickStep,
    this.children = const <FNStep>[],
  }) : super(key: key);

  // ****************** Props ******************
  /// 当前步骤
  final int active;

  /// 显示方向，可选值为 `vertical` `horizontal`
  final Axis direction;

  /// 激活状态颜色
  final Color? activeColor;

  /// 未激活状态颜色
  final Color? inactiveColor;

  /// 激活状态底部图标名称
  final IconData? activeIconName;

  /// 激活状态底部图标访问链接
  final String? activeIconUrl;

  /// 未激活状态底部图标名称
  final IconData? inactiveIconName;

  /// 未激活状态底部图标访问链接
  final String? inactiveIconUrl;

  /// 已完成步骤对应的底部图标名称，优先级高于 `inactiveIcon`
  final IconData? finishIconName;

  /// 已完成步骤对应的底部图标访问链接，优先级高于 `inactiveIcon`
  final String? finishIconUrl;

  // ****************** Events ******************

  /// 点击步骤的标题或图标时触发
  final ValueChanged<int>? onClickStep;

  // ****************** Slots ******************
  // 子步骤
  final List<FNStep> children;

  @override
  Widget build(BuildContext context) {
    final bool isRow = direction == Axis.horizontal;
    FNStepThemeData contextThemeData = FNStepTheme.of(context);
    final List<Widget> content = children
        .take(children.length - 1)
        .map<Widget>((Widget e) => isRow ? Expanded(child: e) : e)
        .toList();

    return Container(
      color: contextThemeData.stepsBackgroundColor,
      padding: isRow
          ? const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0)
          : const EdgeInsets.only(left: FNColors.paddingXl),
      child: isRow
          ? Container(
              padding: const EdgeInsets.only(bottom: 22.0),
              margin: const EdgeInsets.only(bottom: 10.0),
              child: FNStepsScope(
                parent: this,
                child: Stack(
                  children: <Widget>[
                    Row(
                      children: content,
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: children.last,
                    ),
                  ],
                ),
              ),
            )
          : FNStepsScope(
              parent: this,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
    );
  }

  void onClickSubStep(int index) {
    onClickStep?.call(index);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties.add(DiagnosticsProperty<int>('active', active, defaultValue: 0));
    properties.add(DiagnosticsProperty<Axis>('direction', direction,
        defaultValue: Axis.horizontal));
    properties.add(DiagnosticsProperty<Color>('activeColor', activeColor));
    properties.add(DiagnosticsProperty<Color>('inactiveColor', inactiveColor));
    properties
        .add(DiagnosticsProperty<IconData>('activeIconName', activeIconName));
    properties.add(DiagnosticsProperty<String>('activeIconUrl', activeIconUrl));

    properties.add(
        DiagnosticsProperty<IconData>('inactiveIconName', inactiveIconName));
    properties
        .add(DiagnosticsProperty<String>('inactiveIconUrl', inactiveIconUrl));
    properties
        .add(DiagnosticsProperty<IconData>('finishIconName', finishIconName));
    properties.add(DiagnosticsProperty<String>('finishIconUrl', finishIconUrl));

    super.debugFillProperties(properties);
  }
}

class FNStepsScope extends InheritedWidget {
  const FNStepsScope({
    Key? key,
    required this.parent,
    required Widget child,
  }) : super(key: key, child: child);

  final FNUISteps parent;

  static FNStepsScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FNStepsScope>();
  }

  @override
  bool updateShouldNotify(FNStepsScope oldWidget) {
    return parent != oldWidget.parent;
  }
}
