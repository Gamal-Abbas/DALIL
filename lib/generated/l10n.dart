// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Explore the\nAncient World`
  String get title1 {
    return Intl.message(
      'Explore the\nAncient World',
      name: 'title1',
      desc: '',
      args: [],
    );
  }

  /// `Step into Egypt’s greatest treasures and uncover hidden stories.`
  String get desc1 {
    return Intl.message(
      'Step into Egypt’s greatest treasures and uncover hidden stories.',
      name: 'desc1',
      desc: '',
      args: [],
    );
  }

  /// `AI Guided\nExperience`
  String get title2 {
    return Intl.message(
      'AI Guided\nExperience',
      name: 'title2',
      desc: '',
      args: [],
    );
  }

  /// `Let smart technology guide you through every monument.`
  String get desc2 {
    return Intl.message(
      'Let smart technology guide you through every monument.',
      name: 'desc2',
      desc: '',
      args: [],
    );
  }

  /// `Unlock the\nSecrets of`
  String get title3 {
    return Intl.message(
      'Unlock the\nSecrets of',
      name: 'title3',
      desc: '',
      args: [],
    );
  }

  /// `Antiquity`
  String get antiquity {
    return Intl.message(
      'Antiquity',
      name: 'antiquity',
      desc: '',
      args: [],
    );
  }

  /// `Experience history as a private gallery across the Nile.`
  String get desc3 {
    return Intl.message(
      'Experience history as a private gallery across the Nile.',
      name: 'desc3',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get start {
    return Intl.message(
      'Get Started',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `ENGLISH (UK)`
  String get language {
    return Intl.message(
      'ENGLISH (UK)',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Kings`
  String get kings {
    return Intl.message(
      'Kings',
      name: 'kings',
      desc: '',
      args: [],
    );
  }

  /// `Eras`
  String get eras {
    return Intl.message(
      'Eras',
      name: 'eras',
      desc: '',
      args: [],
    );
  }

  /// `Attractions`
  String get attractions {
    return Intl.message(
      'Attractions',
      name: 'attractions',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to`
  String get welcome {
    return Intl.message(
      'Welcome to',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `History Awaits`
  String get historyAwaits {
    return Intl.message(
      'History Awaits',
      name: 'historyAwaits',
      desc: '',
      args: [],
    );
  }

  /// `Discover artifacts, legendary kings,\nand the eras that shaped our world.`
  String get homeDesc {
    return Intl.message(
      'Discover artifacts, legendary kings,\nand the eras that shaped our world.',
      name: 'homeDesc',
      desc: '',
      args: [],
    );
  }

  /// `DALIL`
  String get dalil {
    return Intl.message(
      'DALIL',
      name: 'dalil',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
