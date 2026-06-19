part of 'folders_bloc.dart';

@immutable
final class FoldersState extends Equatable {
  const FoldersState({
    this.allFolders = const [],
    this.status = FoldersStatus.initial,
    this.errorMessage,
  });

  final List<Folder> allFolders;
  final FoldersStatus status;
  final String? errorMessage;

  FoldersState copyWith({
    List<Folder>? allFolders,
    FoldersStatus? status,
    String? errorMessage,
  }) {
    return FoldersState(
      allFolders: allFolders ?? this.allFolders,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    allFolders,
    status,
    if (errorMessage != null) errorMessage!,
  ];
}

enum FoldersStatus { initial, loading, loaded, error }
