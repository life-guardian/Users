import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenShimmerEffect extends StatelessWidget {
  const HomeScreenShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    Color themeColorSecondary = Theme.of(context).colorScheme.onBackground;
    Brightness currentBrightness = MediaQuery.of(context).platformBrightness;

    Widget shimmerContainer({double? width, double? height = 20}) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: themeColorSecondary,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    Widget cardRow() {
      return Row(
        children: [
          Expanded(
            child: shimmerContainer(height: 130),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: shimmerContainer(height: 130),
          ),
        ],
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: currentBrightness == Brightness.light
              ? Colors.grey.shade300
              : Theme.of(context).colorScheme.background,
          highlightColor: currentBrightness == Brightness.light
              ? Colors.grey.shade100
              : Theme.of(context).colorScheme.secondary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: themeColorSecondary,
                        ),
                        const SizedBox(
                          width: 18,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerContainer(width: 80),
                            const SizedBox(
                              height: 8,
                            ),
                            shimmerContainer(
                              width: 120,
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    shimmerContainer(
                      width: double.infinity,
                      height: 80,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: shimmerContainer(
                        width: 120,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    cardRow(),
                    const SizedBox(
                      height: 20,
                    ),
                    cardRow(),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: shimmerContainer(
                        width: 120,
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    cardRow(),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(21),
                    topRight: Radius.circular(21),
                  ),
                  color: themeColorSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
