import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/widgets/widgets.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/features/music_plyer/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/domain/enums/enums.dart';
import 'package:music_player/features/songs/presentation/bloc/bloc.dart';
import 'package:music_player/features/songs/presentation/pages/pages.dart';
import 'package:music_player/features/songs/presentation/widgets/widgets.dart';

class FoldersView extends StatelessWidget {
  const FoldersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoldersBloc, FoldersState>(
      builder: (context, foldersState) {
        if (foldersState.status == FoldersStatus.loading) {
          return const Loading();
        }

        if (foldersState.status == FoldersStatus.error) {
          return SongsErrorLoading(
            eyebrow: context.localization.folders,
            title: context.localization.libraryLoadErrorTitle,
            message: context.localization.libraryLoadErrorMessage,
            onRetry: () => context.read<FoldersBloc>().add(
              const LoadFoldersEvent(),
            ),
          );
        }

        final folders = foldersState.allFolders;
        if (folders.isEmpty) {
          return NoSongsWidget(
            eyebrow: context.localization.folders,
            title: context.localization.emptyFoldersTitle,
            message: context.localization.emptyFoldersMessage,
            onRefresh: () => context.read<FoldersBloc>().add(
              const LoadFoldersEvent(),
            ),
          );
        }

        final mediaQuery = MediaQuery.of(context);
        final isWideCompact =
            mediaQuery.size.width >= 700 && mediaQuery.size.height < 620;
        final hasMiniPlayer = context
            .read<MusicPlayerBloc>()
            .state
            .playList
            .isNotEmpty;
        final bottomPadding = hasMiniPlayer
            ? (isWideCompact ? 104.0 : 132.0)
            : 16.0;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 6, bottom: bottomPadding),
          itemCount: folders.length,
          itemBuilder: (context, index) {
            final folder = folders[index];
            return FolderItem(
              folder: folder,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => AppRouteBlocScope.fromContext(
                      context: context,
                      child: QuerySongsPage(
                        fromType: SongsFromType.folderPath,
                        where: folder.path,
                        title: folder.name,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
