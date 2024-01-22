import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spons/l10n/messages_all_locales.dart';

class MyLocalization {
  static Future<MyLocalization> load(Locale locale) {
    final String name =
        locale.countryCode!.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return MyLocalization();
    });
  }

  static MyLocalization? of(BuildContext context) {
    return Localizations.of<MyLocalization>(context, MyLocalization);
  }

  String get helloWorld {
    return Intl.message(
      'Hello World',
      name: 'helloWorld',
      desc: 'Kata Hello World', /* Optional */
    );
  }

  String get search {
    return Intl.message(
      'Pencarian',
      name: 'search',
      desc: 'Pencarian', /* Optional */
    );
  }

  String get descSearch {
    return Intl.message(
      'Coba fitur pencarian untuk menelusuri film yang kamu pikirkan',
      name: 'descSearch',
      desc:
          'Coba fitur pencarian untuk menelusuri film yang kamu pikirkan', /* Optional */
    );
  }

  String get watchlist {
    return Intl.message(
      'daftar pantauan',
      name: 'watchlist',
      desc: 'daftar pantauan', /* Optional */
    );
  }

  String get descWatchlist {
    return Intl.message(
      'film favorit kosong ?\n coba fitur favorit di film detail dengan menambahkan pada tombol film favorit',
      name: 'descWatchlist',
      desc:
          'film favorit kosong ?\n coba fitur favorit di film detail untuk menambahkan pada tombol film favorit', /* Optional */
    );
  }

  String get settings {
    return Intl.message(
      'Pengaturan',
      name: 'settings',
      desc: 'Pengaturan', /* Optional */
    );
  }

  String get languangeWords {
    return Intl.message(
      'Bahasa',
      name: 'languangeWords',
      desc: 'Bahasa', /* Optional */
    );
  }

  String get profile {
    return Intl.message(
      'Profil',
      name: 'profile',
      desc: 'Profil', /* Optional */
    );
  }

  String get trending {
    return Intl.message(
      'Sedang Tren',
      name: 'trending',
      desc: 'Sedang Tren', /* Optional */
    );
  }

  String get recommended {
    return Intl.message(
      'Rekomendasi',
      name: 'recommended',
      desc: 'Rekomendasi', /* Optional */
    );
  }

  String get nowPlaying {
    return Intl.message(
      'Sedang Tayang',
      name: 'nowPlaying',
      desc: 'Sedang Tayang', /* Optional */
    );
  }

  //Detail movie dart
  String get favorite {
    return Intl.message(
      'Tambah',
      name: 'favorite',
      desc: 'Tambah', /* Optional */
    );
  }

  String get moreInfo {
    return Intl.message(
      'Informasi Lanjut',
      name: 'moreInfo',
      desc: 'Informasi Lanjut', /* Optional */
    );
  }

  String get rating {
    return Intl.message(
      'Nilai Film',
      name: 'rating',
      desc: 'Nilai Film', /* Optional */
    );
  }

  String get voting {
    return Intl.message(
      'Kontribusi',
      name: 'voting',
      desc: 'Kontribusi', /* Optional */
    );
  }

  String get popularity {
    return Intl.message(
      'Popularitas',
      name: 'popularity',
      desc: 'Popularitas', /* Optional */
    );
  }

  String get ratedFor {
    return Intl.message(
      'Dinilai Untuk',
      name: 'ratedFor',
      desc: 'Dinilai Untuk', /* Optional */
    );
  }

  String get premiumPier {
    return Intl.message(
      'Nonton Iklan',
      name: 'premiumPier',
      desc: 'Nonton Iklan',
    );
  }

  String get continueWatchAds {
    return Intl.message(
      'Pengalaman sponsor iklan gratis. Tonton iklan Video singkat untuk Menghapus semua iklan untuk iklan terbuka kecuali Anda menutup aplikasi secara permanen',
      name: 'continueWatchAds',
      desc:
          'Pengalaman sponsor iklan gratis. Tonton iklan Video singkat untuk Menghapus semua iklan untuk iklan terbuka kecuali Anda menutup aplikasi secara permanen',
    );
  }

  String get about {
    return Intl.message(
      'Tentang Kami',
      name: 'about',
      desc: 'Tentang Kami',
    );
  }
}
