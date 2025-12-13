import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/views/songs_view.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/search/presentation/pages/search_songs_page.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';
import 'package:music_player/injection/service_locator.dart';

class QuerySongsPage extends StatefulWidget {
  const QuerySongsPage({
    required this.title,
    required this.where,
    required this.fromType,
    super.key,
  });

  final String title;
  final Object where;
  final SongsFromType fromType;

  @override
  State<QuerySongsPage> createState() => _QuerySongsPageState();
}

class _QuerySongsPageState extends State<QuerySongsPage> {
  late final QuerySongsBloc querySongsBloc;

  @override
  void initState() {
    querySongsBloc = QuerySongsBloc(getIt());
    querySongsBloc.add(
      LoadQuerySongsEvent(songsFromType: widget.fromType, where: widget.where),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QuerySongsBloc>(
      create: (context) => querySongsBloc,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            widget.title,
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const SearchSongsPage(),
                  ),
                );
              },
              tooltip: context.localization.searchSongs,
              icon: const Icon(
                Icons.search,
              ),
            ).paddingSymmetric(horizontal: 6),
          ],
        ),
        body: BlocBuilder<QuerySongsBloc, QuerySongsState>(
          builder: (_, querySongsState) {
            // Handle loading state
            if (querySongsState.status == QuerySongsStatus.loading) {
              return const Loading();
            }

            // Handle error state
            if (querySongsState.status == QuerySongsStatus.error) {
              return SongsErrorLoading(
                message: context.localization.errorLoadingSongs,
                onRetry: () => querySongsBloc.add(
                  LoadQuerySongsEvent(
                    where: widget.where,
                    songsFromType: widget.fromType,
                    sortType: querySongsState.sortType,
                  ),
                ),
              );
            }

            // Handle empty songs
            if (querySongsState.songs.isEmpty) {
              return NoSongsWidget(
                message: context.localization.noSongTryAgain,
                onRefresh: () => querySongsBloc.add(
                  LoadQuerySongsEvent(
                    where: widget.where,
                    songsFromType: widget.fromType,
                    sortType: querySongsState.sortType,
                  ),
                ),
              );
            }

            final songs = querySongsState.songs;

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FilterButton(
                      onTap: () async {
                        final selectedSortType =
                            await SongsFilterBottomSheet.show(
                              context: context,
                              selectedSortType: querySongsState.sortType,
                            );
                        if (selectedSortType != null) {
                          querySongsBloc.add(
                            LoadQuerySongsEvent(
                              where: widget.where,
                              songsFromType: widget.fromType,
                              sortType: selectedSortType,
                            ),
                          );
                        }
                      },
                    ),
                    SongsCount(songCount: songs.length),
                  ],
                ).padding(value: 12),

                Expanded(
                  child: SongsView(
                    songs: songs,
                    onRefresh: () async {
                      querySongsBloc.add(
                        LoadQuerySongsEvent(
                          where: widget.where,
                          songsFromType: widget.fromType,
                          sortType: querySongsState.sortType,
                        ),
                      );
                      await Future<void>.delayed(
                        const Duration(milliseconds: 300),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
