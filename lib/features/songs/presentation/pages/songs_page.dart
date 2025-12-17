import 'package:flutter/material.dart';
import 'package:music_player/features/search/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/views/views.dart';
import 'package:music_player/features/songs/presentation/widgets/songs_appbar.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({
    super.key,
  });

  @override
  State<SongsPage> createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage>
    with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final PageController pageController;
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    pageController = PageController();
    super.initState();
  }

  void animateToNewPage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SongsAppbar(
        onSearchButtonPressed: _onSearchButtonPressed,
      ),
      body: Column(
        children: [
          CategoryTabbar(
            tabController: tabController,
            onTabChanged: animateToNewPage,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: (newPageIndex) {
                tabController.animateTo(newPageIndex);
              },
              children: const [
                AllSongsView(),
                AlbumsView(),
                ArtistsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSearchButtonPressed() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const SearchSongsPage(),
      ),
    );
  }
}
