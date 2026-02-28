import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/products/product_bloc.dart';
import '../../features/products/product_event.dart';
import 'widgets/home_banner_section.dart';
import 'widgets/home_product_list.dart';
import 'widgets/sliver_tab_header.dart';

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

  final List<String> _categories = const ['all', "men's clothing", "women's clothing"];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController(viewportFraction: 0.92);
    _tabController = TabController(length: _categories.length, vsync: this);
    _loadProducts();

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) _loadProducts();
    });
  }

  void _loadProducts() {
    context.read<ProductBloc>().add(LoadProducts(_categories[_tabController.index]));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bannerController.dispose();
    super.dispose();
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
            onRefresh: () async => _loadProducts(),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 260,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: HomeBannerSection(
                      controller: _bannerController,
                      banners: _banners,
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
                      indicatorPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [Color(0xff42A5F5), Color(0xff1E88E5)],
                        ),
                      ),
                      tabs: const [Tab(text: 'All'), Tab(text: 'Men'), Tab(text: 'Women')],
                    ),
                    controller: _tabController,
                  ),
                ),
                const HomeProductList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}