import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:music_player/core/constants/constants.dart';
import 'package:music_player/extensions/extensions.dart';
import 'package:music_player/injection/service_locator.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

/// Widget displaying song/album artwork with fallback to placeholder.
///
/// Features:
/// - Queries device media store for artwork
/// - Falls back to default cover image if unavailable
/// - Configurable size, quality, and border radius
/// - Handles both audio and image artwork types
class ArtImageWidget extends StatefulWidget {
  const ArtImageWidget({
    required this.id,
    this.type = ArtworkType.AUDIO,
    this.size = 54,
    this.quality = 70,
    this.qualitySize = 200,
    this.format = ArtworkFormat.JPEG,
    this.defaultCoverBg,
    this.artworkQuality = FilterQuality.medium,
    this.borderRadius,
    this.artworkFit = BoxFit.cover,
    this.defaultCover = ImageAssets.songCover,
    super.key,
  });

  final int id;
  final ArtworkType type;
  final double size;
  final double? borderRadius;
  final int quality;
  final int qualitySize;
  final ArtworkFormat format;
  final FilterQuality artworkQuality;
  final BoxFit artworkFit;
  final String defaultCover;
  final Color? defaultCoverBg;

  @override
  State<ArtImageWidget> createState() => _ArtImageWidgetState();
}

class _ArtImageWidgetState extends State<ArtImageWidget> {
  static const int _maxCachedArtworks = 250;
  static final OnAudioQuery _audioQuery = getIt<OnAudioQuery>();
  static final LinkedHashMap<_ArtworkCacheKey, Uint8List> _artworkCache =
      LinkedHashMap<_ArtworkCacheKey, Uint8List>();
  static final Map<_ArtworkCacheKey, Future<Uint8List?>> _pendingArtwork =
      <_ArtworkCacheKey, Future<Uint8List?>>{};

  late _ArtworkCacheKey _cacheKey;
  late Future<Uint8List?> _artworkFuture;

  @override
  void initState() {
    super.initState();
    _cacheKey = _buildCacheKey();
    _artworkFuture = _loadArtwork(_cacheKey);
  }

  @override
  void didUpdateWidget(covariant ArtImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextCacheKey = _buildCacheKey();
    if (nextCacheKey != _cacheKey) {
      _cacheKey = nextCacheKey;
      _artworkFuture = _loadArtwork(_cacheKey);
    }
  }

  _ArtworkCacheKey _buildCacheKey() {
    return _ArtworkCacheKey(
      id: widget.id,
      type: widget.type,
      format: widget.format,
      quality: widget.quality,
      qualitySize: widget.qualitySize,
    );
  }

  Future<Uint8List?> _loadArtwork(_ArtworkCacheKey cacheKey) {
    final cachedArtwork = _artworkCache.remove(cacheKey);
    if (cachedArtwork != null) {
      _artworkCache[cacheKey] = cachedArtwork;
      return SynchronousFuture<Uint8List?>(cachedArtwork);
    }

    final pendingArtwork = _pendingArtwork[cacheKey];
    if (pendingArtwork != null) {
      return pendingArtwork;
    }

    final artworkFuture = _audioQuery
        .queryArtwork(
          cacheKey.id,
          cacheKey.type,
          format: cacheKey.format,
          size: cacheKey.qualitySize,
          quality: cacheKey.quality,
        )
        .then((artworkBytes) {
          if (artworkBytes != null && artworkBytes.isNotEmpty) {
            _cacheArtwork(cacheKey, artworkBytes);
          }
          return artworkBytes;
        })
        .whenComplete(() {
          _pendingArtwork.remove(cacheKey);
        });

    _pendingArtwork[cacheKey] = artworkFuture;
    return artworkFuture;
  }

  void _cacheArtwork(_ArtworkCacheKey cacheKey, Uint8List artworkBytes) {
    _artworkCache.remove(cacheKey);
    _artworkCache[cacheKey] = artworkBytes;
    while (_artworkCache.length > _maxCachedArtworks) {
      _artworkCache.remove(_artworkCache.keys.first);
    }
  }

  BorderRadius _artworkBorderRadius() {
    return BorderRadius.circular(widget.borderRadius ?? (widget.size / 2));
  }

  Widget _buildFallback(BuildContext context) {
    return ClipRRect(
      borderRadius: _artworkBorderRadius(),
      child: ColoredBox(
        color: widget.defaultCoverBg ?? context.theme.scaffoldBackgroundColor,
        child: Image.asset(
          widget.defaultCover,
          fit: widget.artworkFit,
          width: widget.size,
          height: widget.size,
        ),
      ),
    );
  }

  Widget _buildArtwork(Uint8List artworkBytes) {
    return ClipRRect(
      borderRadius: _artworkBorderRadius(),
      child: Image.memory(
        artworkBytes,
        width: widget.size,
        height: widget.size,
        fit: widget.artworkFit,
        filterQuality: widget.artworkQuality,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => _buildFallback(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _artworkFuture,
      builder: (context, snapshot) {
        final artworkBytes = snapshot.data;
        if (artworkBytes != null && artworkBytes.isNotEmpty) {
          return _buildArtwork(artworkBytes);
        }
        return _buildFallback(context);
      },
    );
  }
}

@immutable
class _ArtworkCacheKey {
  const _ArtworkCacheKey({
    required this.id,
    required this.type,
    required this.format,
    required this.quality,
    required this.qualitySize,
  });

  final int id;
  final ArtworkType type;
  final ArtworkFormat format;
  final int quality;
  final int qualitySize;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is _ArtworkCacheKey &&
        other.id == id &&
        other.type == type &&
        other.format == format &&
        other.quality == quality &&
        other.qualitySize == qualitySize;
  }

  @override
  int get hashCode => Object.hash(id, type, format, quality, qualitySize);
}
