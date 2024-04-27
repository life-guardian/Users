import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListviewShimmerEffect extends StatelessWidget {
  const ListviewShimmerEffect({super.key, this.cardHeight, s});
  final double? cardHeight;

  @override
  Widget build(BuildContext context) {
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;

    return ListView.separated(
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: currentBrightness == Brightness.light
              ? Colors.grey.shade300
              : Theme.of(context).colorScheme.background,
          highlightColor: currentBrightness == Brightness.light
              ? Colors.grey.shade100
              : Theme.of(context).colorScheme.secondary,
          child: Container(
            height: cardHeight ?? 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 10,
        );
      },
      itemCount: 10,
    );
  }
}
