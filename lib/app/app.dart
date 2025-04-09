import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_cam_news/app/theme/app_theme.dart';
import 'package:geo_cam_news/app/theme/theme_bloc.dart';
import 'package:geo_cam_news/app/theme/theme_event.dart';
import 'package:geo_cam_news/app/theme/theme_state.dart';
import 'package:geo_cam_news/features/geocam/views/geocam_page.dart';
import 'package:geo_cam_news/features/news/views/news_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'GeoCam News',
          theme: state.isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
          home: const MainTabs(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MainTabs extends StatefulWidget {
  const MainTabs({super.key});

  @override
  State<MainTabs> createState() => _MainTabsState();
}

class _MainTabsState extends State<MainTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoCam News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.camera_alt), text: 'GeoCam'),
            Tab(icon: Icon(Icons.article), text: 'News'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [GeocamPage(), NewsPage()],
      ),
    );
  }
}
