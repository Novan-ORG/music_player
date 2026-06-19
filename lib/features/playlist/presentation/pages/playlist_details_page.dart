import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/domain/entities/song.dart';
import 'package:music_player/core/mixins/mixins.dart';
import 'package:music_player/core/views/views.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/playlist/domain/domain.dart';
import 'package:music_player/features/playlist/presentation/bloc/bloc.dart';
import 'package:music_player/features/playlist/presentation/widgets/widgets.dart';
import 'package:music_player/features/search/presentation/pages/search_songs_page.dart';
import 'package:music_player/injection/service_locator.dart';

class PlaylistDetailsPage extends StatelessWidget {
  const PlaylistDetailsPage({required this.playlistModel, super.key});
  final Playlist playlistModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PlaylistDetailsBloc(
        playlist: playlistModel,
        getPlaylistSongs: getIt.get(),
        getRecentlyPlayedSongs: getIt.get(),
      ),
      child: _PlaylistDetailsView(playlistModel),
    );
  }
}

class _PlaylistDetailsView extends StatefulWidget {
  const _PlaylistDetailsView(this.playlist);
  final Playlist playlist;

  @override
  State<_PlaylistDetailsView> createState() => _PlaylistDetailsViewState();
}

class _PlaylistDetailsViewState extends State<_PlaylistDetailsView>
    with PlaylistManagementMixin {
  late final PlaylistDetailsBloc _detailsBloc = context
      .read<PlaylistDetailsBloc>();
  bool get _isRecentlyPlayed => widget.playlist.id == -1;

  @override
  void initState() {
    super.initState();
    _loadPlaylistSongs();
  }

  void _loadPlaylistSongs() {
    _detailsBloc.add(
      const GetPlaylistSongsEvent(),
    );
  }

  Future<void> onRefresh() async {
    _loadPlaylistSongs();
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }

  Future<void> _onSearchButtonPressed() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AppRouteBlocScope.fromContext(
          context: context,
          child: const SearchSongsPage(),
        ),
      ),
    );
  }

  Future<void> _onAddSongsPressed(
    Playlist playlist,
    List<Song> songs,
  ) async {
    if (_isRecentlyPlayed) {
      return;
    }

    final result = await addSongsToPlaylist(
      playlist,
      songs.map((e) => e.id).toSet(),
    );
    if (result != null && mounted) {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      _loadPlaylistSongs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PlaylistDetailsBloc, PlaylistDetailsState>(
      listener: (context, state) {
        final errorMessage = state.errorMessage;
        if (state.status == PlaylistDetailsStatus.failure &&
            errorMessage != null) {
          AppSnackBar.showError(
            context,
            title: context.localization.error,
            message: errorMessage,
          );
        }
      },
      builder: (context, state) {
        final theme = context.theme;
        final songCount = state.songs.length;
        final songs = state.songs;
        final isLoading = state.status == PlaylistDetailsStatus.loading;
        final hasSongs = songs.isNotEmpty;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.18),
                  const Color(0xFF00BFA6).withValues(alpha: 0.08),
                  theme.scaffoldBackgroundColor,
                  theme.scaffoldBackgroundColor,
                ],
                stops: const [0, 0.18, 0.42, 1],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  PlaylistDetailsAppbar(
                    playlist: state.playlist,
                    songCount: songCount,
                    onBackPressed: () => Navigator.of(context).maybePop(),
                    onSearchButtonPressed: _onSearchButtonPressed,
                    onAddSongsPressed: _isRecentlyPlayed
                        ? null
                        : () => _onAddSongsPressed(state.playlist, songs),
                  ),
                  Expanded(
                    child: isLoading
                        ? const Loading()
                        : hasSongs
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  8,
                                  16,
                                  8,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      context.localization.songs,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const Spacer(),
                                    SongsCount(songCount: songCount),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SongsView(
                                  songs: songs,
                                  playlist: state.playlist,
                                  onRefresh: onRefresh,
                                ),
                              ),
                            ],
                          )
                        : NoSongsWidget(
                            eyebrow: context.localization.playlist,
                            title: context.localization.noSongInPlaylist,
                            message: _isRecentlyPlayed
                                ? context.localization.playlistRecentHint
                                : context.localization.noSongInThePlaylist,
                            actionLabel: _isRecentlyPlayed
                                ? context.localization.refresh
                                : context.localization.addSongs,
                            onRefresh: _isRecentlyPlayed
                                ? onRefresh
                                : () =>
                                      _onAddSongsPressed(state.playlist, songs),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
