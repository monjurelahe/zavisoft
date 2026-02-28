import 'package:flutter/material.dart';
import 'package:sliver/views/home/widgets/search_bar.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeBannerSection extends StatelessWidget {
  final PageController controller;
  final List<String> banners;

  const HomeBannerSection({
    super.key,
    required this.controller,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 88, 154, 212), Color(0xFFF2F5F9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchBarWidget(),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: PageView.builder(
                controller: controller,
                physics: const BouncingScrollPhysics(),
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(banners[index], fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black26, Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            SmoothPageIndicator(
              controller: controller,
              count: banners.length,
              effect: const ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor: Color.fromARGB(255, 68, 89, 180),
                dotColor: Colors.grey,
                expansionFactor: 3,
                spacing: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}