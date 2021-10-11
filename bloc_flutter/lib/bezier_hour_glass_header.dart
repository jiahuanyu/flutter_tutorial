import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'src/header/refresh_indicator.dart';
import 'src/header/header.dart';

/// BezierHourGlassHeader
class BezierHourGlassHeader extends Header {
  /// Key
  final Key? key;

  /// 颜色
  final Color color;

  /// 背景颜色
  final Color? backgroundColor;

  final LinkHeaderNotifier linkNotifier = LinkHeaderNotifier();

  BezierHourGlassHeader({
    this.key,
    this.color = Colors.white,
    this.backgroundColor = Colors.blue,
    bool enableHapticFeedback = false,
  }) : super(
          extent: 80.0,
          triggerDistance: 80.0,
          float: false,
          enableHapticFeedback: enableHapticFeedback,
          enableInfiniteRefresh: false,
          completeDuration: const Duration(seconds: 1),
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration? completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    // 不能为水平方向以及反向
    assert(axisDirection == AxisDirection.down,
        'Widget can only be vertical and cannot be reversed');
    linkNotifier.contentBuilder(
        context,
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteRefresh,
        success,
        noMore);
    return BezierHourGlassHeaderWidget(
      key: key,
      color: color,
      backgroundColor: backgroundColor,
      linkNotifier: linkNotifier,
    );
  }
}

/// BezierHourGlassHeader组件
class BezierHourGlassHeaderWidget extends StatefulWidget {
  /// 颜色
  final Color color;

  /// 背景颜色
  final Color? backgroundColor;

  final LinkHeaderNotifier linkNotifier;

  const BezierHourGlassHeaderWidget({
    Key? key,
    required this.color,
    this.backgroundColor,
    required this.linkNotifier,
  }) : super(key: key);

  @override
  BezierHourGlassHeaderWidgetState createState() {
    return BezierHourGlassHeaderWidgetState();
  }
}

class BezierHourGlassHeaderWidgetState
    extends State<BezierHourGlassHeaderWidget>
    with TickerProviderStateMixin<BezierHourGlassHeaderWidget> {
  RefreshMode get _refreshState => widget.linkNotifier.refreshState;

  double get _pulledExtent => widget.linkNotifier.pulledExtent;

  double get _indicatorExtent => widget.linkNotifier.refreshIndicatorExtent;

  bool get _noMore => widget.linkNotifier.noMore;

  // 回弹动画
  late AnimationController _backController;
  late Animation<double> _backAnimation;
  double _backAnimationLength = 110.0;
  double _backAnimationPulledExtent = 0.0;
  bool _showBackAnimation = false;

  set showBackAnimation(bool value) {
    if (_showBackAnimation != value) {
      _showBackAnimation = value;
      if (_showBackAnimation) {
        _backAnimationPulledExtent = _pulledExtent - _indicatorExtent;
        _backAnimation = Tween(
                begin: 0.0,
                end: _backAnimationLength + _backAnimationPulledExtent)
            .animate(_backController);
        _backController.reset();
        _backController.forward();
      }
    }
  }

  // 是否显示HourGlass
  bool _showHourGlass = false;

  // 是否显示水波纹
  bool _showRipple = false;

  @override
  void initState() {
    super.initState();
    // 回弹动画
    _backController = new AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _backAnimation =
        Tween(begin: 0.0, end: _backAnimationLength).animate(_backController);
  }

  @override
  void dispose() {
    _backController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_noMore) return Container();
    // 计算小球透明度
    double ballOpacity;
    if (_refreshState != RefreshMode.drag &&
        _refreshState != RefreshMode.armed) {
      ballOpacity = 0.0;
    } else if (_pulledExtent > _indicatorExtent + 40.0) {
      ballOpacity = 1.0;
    } else if (_pulledExtent > _indicatorExtent) {
      ballOpacity = (_pulledExtent - _indicatorExtent) / 40.0;
    } else {
      ballOpacity = 0.0;
    }
    // 启动回弹动画
    if (_refreshState == RefreshMode.armed) {
      showBackAnimation = true;
      _showHourGlass = true;
    } else if (_refreshState == RefreshMode.done) {
      _showHourGlass = false;
      _showRipple = true;
    } else if (_refreshState == RefreshMode.inactive) {
      showBackAnimation = false;
      if (_pulledExtent == 0.0) {
        _showRipple = false;
      }
    }
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Column(
            children: <Widget>[
              Container(
                height: _indicatorExtent,
                width: double.infinity,
                color: widget.backgroundColor,
                child: Stack(
                  children: <Widget>[
                    // 回弹动画组件
                    AnimatedBuilder(
                      animation: _backAnimation,
                      builder: (context, child) {
                        double offset = 0.0;
                        if (_backAnimation.value >=
                            _backAnimationPulledExtent) {
                          var animationValue =
                              _backAnimation.value - _backAnimationPulledExtent;
                          if (animationValue <= 30.0) {
                            offset = animationValue;
                          } else if (animationValue > 30.0 &&
                              animationValue <= 50.0) {
                            offset = (20.0 - (animationValue - 30.0)) * 3 / 2;
                          } else if (animationValue > 50.0 &&
                              animationValue < 65.0) {
                            offset = animationValue - 50.0;
                          } else if (animationValue > 65.0) {
                            offset = (45.0 - (animationValue - 65.0)) / 3;
                          }
                        }
                        return ClipPath(
                          clipper: CirclePainter(offset: offset, up: false),
                          child: child,
                        );
                      },
                      child: Container(
                        color: widget.color,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    // 五个小球
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Positioned(
                            top: 0.0,
                            bottom: 0.0,
                            left: -400.0,
                            right: -400.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Opacity(
                                  opacity: ballOpacity / 4,
                                  child: Icon(
                                    Icons.lens,
                                    size: 15.0,
                                    color: widget.color,
                                  ),
                                ),
                                Container(
                                  width: _pulledExtent / 3,
                                ),
                                Opacity(
                                  opacity: ballOpacity / 2,
                                  child: Icon(
                                    Icons.lens,
                                    size: 15.0,
                                    color: widget.color,
                                  ),
                                ),
                                Container(
                                  width: _pulledExtent / 3,
                                ),
                                Opacity(
                                  opacity: ballOpacity,
                                  child: Icon(
                                    Icons.lens,
                                    size: 15.0,
                                    color: widget.color,
                                  ),
                                ),
                                Container(
                                  width: _pulledExtent / 3,
                                ),
                                Opacity(
                                  opacity: ballOpacity / 2,
                                  child: Icon(
                                    Icons.lens,
                                    size: 15.0,
                                    color: widget.color,
                                  ),
                                ),
                                Container(
                                  width: _pulledExtent / 3,
                                ),
                                Opacity(
                                  opacity: ballOpacity / 4,
                                  child: Icon(
                                    Icons.lens,
                                    size: 15.0,
                                    color: widget.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 旋转动画组件
                    AnimatedCrossFade(
                      firstChild: SizedBox(
                        width: double.infinity,
                        height: _indicatorExtent,
                        child: SpinKitHourGlass(
                          color: widget.color,
                          size: 30.0,
                        ),
                      ),
                      secondChild: SizedBox(
                        width: double.infinity,
                        height: _indicatorExtent,
                      ),
                      crossFadeState: _showHourGlass
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: Duration(milliseconds: 400),
                    ),
                    // 水波纹动画组件
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Center(
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              height: _indicatorExtent,
                              width: _showRipple ? constraints.maxWidth : 0.0,
                              color: widget.color,
                              duration: _showRipple
                                  ? Duration(milliseconds: 300)
                                  : Duration(milliseconds: 1),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: _pulledExtent > _indicatorExtent
                    ? _pulledExtent - _indicatorExtent
                    : 0.0,
                child: ClipPath(
                  clipper: CirclePainter(
                    offset: _showBackAnimation
                        ? _backAnimation.value < _backAnimationPulledExtent
                            ? _backAnimationPulledExtent - _backAnimation.value
                            : 0.0
                        : (_pulledExtent > _indicatorExtent &&
                                _refreshState != RefreshMode.refresh &&
                                _refreshState != RefreshMode.refreshed &&
                                _refreshState != RefreshMode.done
                            ? _pulledExtent - _indicatorExtent
                            : 0.0),
                    up: true,
                  ),
                  child: Container(
                    color: widget.backgroundColor,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 圆面切割
class CirclePainter extends CustomClipper<Path> {
  final double offset;
  final bool up;

  CirclePainter({required this.offset, required this.up});

  @override
  Path getClip(Size size) {
    final path = new Path();
    if (!up) path.moveTo(0.0, size.height);
    path.cubicTo(
        0.0,
        up ? 0.0 : size.height,
        size.width / 2,
        up ? offset * 2 : size.height - offset * 2,
        size.width,
        up ? 0.0 : size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return oldClipper != this;
  }
}

/// HourGlass
/// 来源于flutter_spinkit
/*
MIT License
Copyright (c) 2018 Jeremiah Ogbomo
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */
class SpinKitHourGlass extends StatefulWidget {
  final Color color;
  final double size;

  const SpinKitHourGlass({
    Key? key,
    required this.color,
    this.size = 50.0,
  }) : super(key: key);

  @override
  _SpinKitHourGlassState createState() => _SpinKitHourGlassState();
}

class _SpinKitHourGlassState extends State<SpinKitHourGlass>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    _animation1 = Tween(begin: 0.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 1.0, curve: Curves.easeOut),
      ),
    )..addListener(() => setState(() => <String, void>{}));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Matrix4 transform = Matrix4.identity()
      ..rotateZ((_animation1.value) * math.pi);
    return Center(
      child: Transform(
        transform: transform,
        alignment: FractionalOffset.center,
        child: CustomPaint(
          child: Container(
            height: widget.size,
            width: widget.size,
          ),
          painter: _HourGlassPainter(color: widget.color),
        ),
      ),
    );
  }
}

class _HourGlassPainter extends CustomPainter {
  Paint p = Paint();
  final double weight;

  _HourGlassPainter({this.weight = 90.0, required Color color}) {
    p.color = color;
    p.strokeWidth = 1.0;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawArc(
      Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
      0.0,
      getRadian(weight),
      true,
      p,
    );
    canvas.drawArc(
      Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
      getRadian(180.0),
      getRadian(weight),
      true,
      p,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double getRadian(double angle) {
    return math.pi / 180 * angle;
  }
}
