part of 'folders_bloc.dart';

@immutable
sealed class FoldersEvent {
  const FoldersEvent();
}

final class LoadFoldersEvent extends FoldersEvent {
  const LoadFoldersEvent();
}
