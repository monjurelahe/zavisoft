import 'package:flutter/material.dart';

class SliverTabHeader extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final TabController controller;

  SliverTabHeader({
    required this.tabBar,
    required this.controller,
  });

  @override
  double get minExtent => tabBar.preferredSize.height + 20;

  @override
  double get maxExtent => tabBar.preferredSize.height + 20;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {

    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      // ✅ horizontal swipe detection
      onHorizontalDragEnd: (details) {

        final velocity = details.primaryVelocity ?? 0;

        if (velocity == 0) return;

        final current = controller.index;

        // swipe left → next tab
        if (velocity < 0 && current < controller.length - 1) {
          controller.animateTo(current + 1);
        }

        // swipe right → previous tab
        if (velocity > 0 && current > 0) {
          controller.animateTo(current - 1);
        }
      },

      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: tabBar,
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverTabHeader oldDelegate) {
    return oldDelegate.tabBar != tabBar ||
        oldDelegate.controller != controller;
  }
}