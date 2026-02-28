import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // প্যাকেজটি ইমপোর্ট করুন
import 'package:sliver/ui/home/product_cart_items.dart';
import 'package:sliver/ui/home/search_bar.dart';
import '../../features/products/product_bloc.dart';
import '../../features/products/product_event.dart';
import '../../features/products/product_state.dart';
import 'sliver_tab_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _bannerController;

  final List<String> _banners = [
    'https://img.freepik.com/premium-vector/online-shopping-banner-via-cellphone-suitable-ecommerce-promotions_541170-3172.jpg',
    'https://img.freepik.com/free-psd/black-friday-super-sale-facebook-cover-banner-template_120329-5177.jpg?semt=ais_rp_progressive&w=740&q=80',
    'https://img.freepik.com/free-vector/online-shopping-horizontal-banner_52683-58701.jpg',
  ];

  final List<String> _categories = const [
    'all',
    "men's clothing",
    "women's clothing",
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.92);
    _tabController = TabController(length: _categories.length, vsync: this);
    context.read<ProductBloc>().add(LoadProducts(_categories[0]));

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      context.read<ProductBloc>().add(
        LoadProducts(_categories[_tabController.index]),
      );
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<ProductBloc>().add(
      LoadProducts(_categories[_tabController.index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFDFEFF), Color(0xFFF1F5FB)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 260,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 88, 154, 212),
                            Color(0xFFF2F5F9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: SearchBarWidget(),
                            ),
                            const SizedBox(height: 14),
                            Expanded(
                              child: PageView.builder(
                                controller: _bannerController,
                                physics: const BouncingScrollPhysics(),
                                itemCount: _banners.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.network(
                                            _banners[index],
                                            fit: BoxFit.cover,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.black.withOpacity(.25),
                                                  Colors.transparent,
                                                ],
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
                              controller: _bannerController,
                              count: _banners.length,
                              effect: const ExpandingDotsEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: Color.fromARGB(
                                  255,
                                  68,
                                  89,
                                  180,
                                ),
                                dotColor: Colors.grey,
                                expansionFactor: 3,
                                spacing: 5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverTabHeader(
                    tabBar: TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      indicatorColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey.shade600,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [Color(0xff42A5F5), Color(0xff1E88E5)],
                        ),
                      ),
                      tabs: const [
                        Tab(text: 'All'),
                        Tab(text: 'Men'),
                        Tab(text: 'Women'),
                      ],
                    ),
                    controller: _tabController,
                  ),
                ),

              

                BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoaded) {
                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final item = state.products[index];
                            return ProductCardWidget(item: item);
                          }, childCount: state.products.length),
                        ),
                      );
                    }
                    if (state is ProductError) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text(state.message)),
                      );
                    }
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
