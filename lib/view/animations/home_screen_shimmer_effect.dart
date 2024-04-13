import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreenShimmerAnimation extends StatelessWidget {
  const HomeScreenShimmerAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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

    return SafeArea(
      child: Shimmer.fromColors(
        baseColor: currentBrightness == Brightness.light
            ? Colors.grey.shade300
            : Theme.of(context).colorScheme.background,
        highlightColor: currentBrightness == Brightness.light
            ? Colors.grey.shade100
            : Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 21,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 18,
                              ),
                              shimmerContainer(width: 80),
                              const SizedBox(
                                height: 8,
                              ),
                              shimmerContainer(
                                width: 140,
                              ),
                            ],
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: themeColorSecondary,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      shimmerContainer(
                        width: size.width / 1.5,
                        height: 30,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      shimmerContainer(
                        width: size.width / 1.8,
                        height: 20,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      shimmerContainer(
                        width: double.infinity,
                        height: 100,
                      ),
                      SizedBox(
                        height: size.height / 11,
                      ),
                      shimmerContainer(
                        width: size.width / 2,
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                shimmerContainer(
                                  width: 190,
                                  height: 140,
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                shimmerContainer(
                                  width: 190,
                                  height: 190,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 21,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                shimmerContainer(
                                  width: 190,
                                  height: 190,
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                shimmerContainer(
                                  width: 190,
                                  height: 140,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
    );
  }
}
