import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// The application name
  ///
  /// In en, this message translates to:
  /// **'Music Player'**
  String get appTitle;

  /// The Settings page localization
  ///
  /// In en, this message translates to:
  /// **''**
  String get settingsPage;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @playback.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get playback;

  /// No description provided for @sleepTimer.
  ///
  /// In en, this message translates to:
  /// **'Sleep Timer'**
  String get sleepTimer;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @min15.
  ///
  /// In en, this message translates to:
  /// **'15 Min'**
  String get min15;

  /// No description provided for @min30.
  ///
  /// In en, this message translates to:
  /// **'30 Min'**
  String get min30;

  /// No description provided for @hour1.
  ///
  /// In en, this message translates to:
  /// **'1 hour'**
  String get hour1;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @sendFeedbackOrSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback or Suggestions'**
  String get sendFeedbackOrSuggestion;

  /// No description provided for @errorOpenEmail.
  ///
  /// In en, this message translates to:
  /// **'Could not open email app.'**
  String get errorOpenEmail;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @selectSleepTimerDuration.
  ///
  /// In en, this message translates to:
  /// **'Select Sleep Timer Duration'**
  String get selectSleepTimerDuration;

  /// No description provided for @aboutContributers.
  ///
  /// In en, this message translates to:
  /// **'About the Contributers'**
  String get aboutContributers;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get seeMore;

  /// No description provided for @seeLess.
  ///
  /// In en, this message translates to:
  /// **'See Less'**
  String get seeLess;

  /// Home page localizations.
  ///
  /// In en, this message translates to:
  /// **''**
  String get homePage;

  /// No description provided for @songs.
  ///
  /// In en, this message translates to:
  /// **'Songs'**
  String get songs;

  /// No description provided for @playlists.
  ///
  /// In en, this message translates to:
  /// **'Playlists'**
  String get playlists;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Songs page localization
  ///
  /// In en, this message translates to:
  /// **''**
  String get songsPage;

  /// No description provided for @permissionDeniedForRingtone.
  ///
  /// In en, this message translates to:
  /// **'Permission not granted to set ringtone'**
  String get permissionDeniedForRingtone;

  /// No description provided for @deleteSong.
  ///
  /// In en, this message translates to:
  /// **'Delete song'**
  String get deleteSong;

  /// No description provided for @areSureYouWantToDeleteSong.
  ///
  /// In en, this message translates to:
  /// **'\'Are you sure you want to delete this song?'**
  String get areSureYouWantToDeleteSong;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Delete from device'**
  String get deleteFromDevice;

  /// No description provided for @favoriteSongs.
  ///
  /// In en, this message translates to:
  /// **'Favorite Songs'**
  String get favoriteSongs;

  /// No description provided for @allSongs.
  ///
  /// In en, this message translates to:
  /// **'All Songs'**
  String get allSongs;

  /// No description provided for @searchSongs.
  ///
  /// In en, this message translates to:
  /// **'Search Songs'**
  String get searchSongs;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @errorLoadingSongs.
  ///
  /// In en, this message translates to:
  /// **'Some error happend while loading songs'**
  String get errorLoadingSongs;

  /// No description provided for @noSongTryAgain.
  ///
  /// In en, this message translates to:
  /// **'No songs found.\nTry refreshing or adding music!'**
  String get noSongTryAgain;

  /// No description provided for @noFavoriteSong.
  ///
  /// In en, this message translates to:
  /// **'No favorite song exist'**
  String get noFavoriteSong;

  /// No description provided for @noSongInPlaylist.
  ///
  /// In en, this message translates to:
  /// **'No song exist in this playlist'**
  String get noSongInPlaylist;

  /// No description provided for @shuffleAllSongs.
  ///
  /// In en, this message translates to:
  /// **'Shuffle All Songs'**
  String get shuffleAllSongs;

  /// No description provided for @sortSongs.
  ///
  /// In en, this message translates to:
  /// **'Sort Songs'**
  String get sortSongs;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @dateAdded.
  ///
  /// In en, this message translates to:
  /// **'Date Added'**
  String get dateAdded;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @album.
  ///
  /// In en, this message translates to:
  /// **'Album'**
  String get album;

  /// No description provided for @albums.
  ///
  /// In en, this message translates to:
  /// **'Albums'**
  String get albums;

  /// No description provided for @artist.
  ///
  /// In en, this message translates to:
  /// **'Artist'**
  String get artist;

  /// No description provided for @artists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get artists;

  /// No description provided for @ascending.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// No description provided for @descending.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'DISMISS'**
  String get dismiss;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'UNDO'**
  String get undo;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @addToPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add to Playlist'**
  String get addToPlaylist;

  /// No description provided for @removeFromPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Playlist'**
  String get removeFromPlaylist;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// Title for delete songs alert dialog
  ///
  /// In en, this message translates to:
  /// **'Delete {count} songs?'**
  String deleteSongsAlertTitle(int count);

  /// No description provided for @deleteSongsAlertContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the selected songs from device?'**
  String get deleteSongsAlertContent;

  /// Subject for sharing songs
  ///
  /// In en, this message translates to:
  /// **'Sharing {count} songs:\n{songsTitleList}'**
  String shareSongsSubject(int count, String songsTitleList);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// Playlist page localization
  ///
  /// In en, this message translates to:
  /// **''**
  String get playListPage;

  /// No description provided for @noPlaylistFound.
  ///
  /// In en, this message translates to:
  /// **'No Playlists Found'**
  String get noPlaylistFound;

  /// No description provided for @createFirstPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create First Playlist'**
  String get createFirstPlaylist;

  /// No description provided for @song.
  ///
  /// In en, this message translates to:
  /// **'Song'**
  String get song;

  /// No description provided for @s.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get s;

  /// No description provided for @createNewPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create New Playlist'**
  String get createNewPlaylist;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @playlistPage.
  ///
  /// In en, this message translates to:
  /// **'Playlists page'**
  String get playlistPage;

  /// No description provided for @addToSelectedPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Add To Selected Playlist'**
  String get addToSelectedPlaylist;

  /// No description provided for @selectPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Select Playlist'**
  String get selectPlaylist;

  /// No description provided for @createPlaylist.
  ///
  /// In en, this message translates to:
  /// **'Create Playlist'**
  String get createPlaylist;

  /// No description provided for @playlistName.
  ///
  /// In en, this message translates to:
  /// **'Playlist Name'**
  String get playlistName;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @renamePlaylist.
  ///
  /// In en, this message translates to:
  /// **'Rename Playlist'**
  String get renamePlaylist;

  /// No description provided for @addSongs.
  ///
  /// In en, this message translates to:
  /// **'Add Songs'**
  String get addSongs;

  /// No description provided for @noSongInThePlaylist.
  ///
  /// In en, this message translates to:
  /// **'No song in the playlist. Add songs to see them here.'**
  String get noSongInThePlaylist;

  /// Music Player page localization
  ///
  /// In en, this message translates to:
  /// **''**
  String get musicPlayerPage;

  /// No description provided for @noSongInQueue.
  ///
  /// In en, this message translates to:
  /// **'No songs in queue'**
  String get noSongInQueue;

  /// No description provided for @upNext.
  ///
  /// In en, this message translates to:
  /// **'Up Next'**
  String get upNext;

  /// AboutUs page localization
  ///
  /// In en, this message translates to:
  /// **''**
  String get aboutUsPage;

  /// No description provided for @talebStory.
  ///
  /// In en, this message translates to:
  /// **'Hi! I\'m Taleb Rafiepour, a passionate mobile developer with years of experience building beautiful and reliable apps for Android and iOS. I love creating user-friendly, high-performance applications that make people\'s lives easier.'**
  String get talebStory;

  /// No description provided for @caroStory.
  ///
  /// In en, this message translates to:
  /// **'Hello! I\'m Caro Zamani, a Product Designer.\nI\'m delighted to have As a designer at the beginning of my professional journey, your feedback is truly valuable and important to me.\nSo, feel free to visit my social media pages so we can share our knowledge and experiences together.'**
  String get caroStory;

  /// No description provided for @elhamStory.
  ///
  /// In en, this message translates to:
  /// **'I am a mobile developer specializing in Flutter. I focus on clean, reliable, and scalable architecture. I have worked on smart apps, banking systems, and social platforms, and I am always exploring new technologies to improve my skills.'**
  String get elhamStory;

  /// No description provided for @appPurpose.
  ///
  /// In en, this message translates to:
  /// **'This app is completely free. If you enjoy using it, please consider supporting us by rating it 5 stars and leaving a kind comment on the app store!'**
  String get appPurpose;

  /// No description provided for @connectWithMe.
  ///
  /// In en, this message translates to:
  /// **'Connect with me'**
  String get connectWithMe;

  /// No description provided for @gmail.
  ///
  /// In en, this message translates to:
  /// **'Gmail'**
  String get gmail;

  /// No description provided for @linktree.
  ///
  /// In en, this message translates to:
  /// **'LinkTree'**
  String get linktree;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @setAsRingtone.
  ///
  /// In en, this message translates to:
  /// **'Set as ringtone'**
  String get setAsRingtone;

  /// No description provided for @sleepTimerActive.
  ///
  /// In en, this message translates to:
  /// **'Sleep Timer is Active'**
  String get sleepTimerActive;

  /// No description provided for @cancelTimer.
  ///
  /// In en, this message translates to:
  /// **'Cancel Timer'**
  String get cancelTimer;

  /// Favorite songs page localization
  ///
  /// In en, this message translates to:
  /// **''**
  String get favoriteSongsPage;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @areYouSureYouWantToClearAllFavorites.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear all favorite songs?'**
  String get areYouSureYouWantToClearAllFavorites;

  /// Add songs to playlist page localization
  ///
  /// In en, this message translates to:
  /// **''**
  String get addSongsPage;

  /// No description provided for @allSongsAlreadyExistInPlaylist.
  ///
  /// In en, this message translates to:
  /// **'All songs already exist in the playlist'**
  String get allSongsAlreadyExistInPlaylist;

  /// No description provided for @addTo.
  ///
  /// In en, this message translates to:
  /// **'Add to'**
  String get addTo;

  /// Button text for adding songs to playlist
  ///
  /// In en, this message translates to:
  /// **'Add ({count})'**
  String add(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
