import 'dart:ui' as ui;

import 'package:flutter/material.dart';
@immutable
class BubbleBackground extends StatelessWidget {
  const BubbleBackground({
    super.key,
    required this.colors,
    this.child,
    required this.context,
  });

  final List<Color> colors;
  final Widget? child;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        scrollable: Scrollable.of(context),
        bubbleContext: context,
        colors: colors,
      ),
      child: child,
    );
  }
}
class BubblePainter extends CustomPainter {
  BubblePainter({
    required ScrollableState scrollable,
    required BuildContext bubbleContext,
    required List<Color> colors,
  })  : _scrollable = scrollable,
        _bubbleContext = bubbleContext,
        _colors = colors,
        super(repaint: scrollable.position);

  final ScrollableState _scrollable;
  final BuildContext _bubbleContext;
  final List<Color> _colors;

  @override
  void paint(Canvas canvas, Size size) {
    // tìm đối tượng cả khả năng cuộn trên giao diện
    final scrollableBox = _scrollable.context.findRenderObject() as RenderBox;
    //tạo ra một hình chữ nhật
    final scrollableRect = Offset.zero & scrollableBox.size;
    //Tìm đối tượng
    final bubbleBox = _bubbleContext.findRenderObject() as RenderBox;
    // Xác định vị trí kích thước của phần tử muốn vẽ trên widget cha chứa nó
    final origin = bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    //Tạo đối tượng vẽ màu theo gradient
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        _colors,
        [0.0, 1.0],
        //ko để màu vượt quá giới hạn kích thước phần tử
        TileMode.clamp,
        // điều chỉnh gradient khớp với tọa độ
        Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
      );
    //dùng canvas vẽ hình chữ nhật dựa  trên kích cỡ của phần tử
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return oldDelegate._scrollable != _scrollable ||
        oldDelegate._bubbleContext != _bubbleContext ||
        oldDelegate._colors != _colors;
  }
}