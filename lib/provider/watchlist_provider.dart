import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WatchlistProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _watchlist = [];

  WatchlistProvider() {
    loadWatchlist();
  }

  List<Map<String, dynamic>> get watchlist => _watchlist;

  void addToWatchlist(Map<String, dynamic> movie) {
    _watchlist.add(movie);
    saveWatchlist();
    notifyListeners();
  }

  void removeFromWatchlist(Map<String, dynamic> movie) {
    _watchlist.remove(movie);
    saveWatchlist();
    notifyListeners();
  }

  bool isMovieInWatchlist(Map<String, dynamic> movie) {
    return _watchlist.contains(movie);
  }

  void toggleMovieInWatchlist(Map<String, dynamic> movie) {
    if (isMovieInWatchlist(movie)) {
      removeFromWatchlist(movie);
    } else {
      addToWatchlist(movie);
    }
  }

  void saveWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('watchlist', json.encode(_watchlist));
  }

  void loadWatchlist() async {
    final prefs = await SharedPreferences.getInstance();
    final storedWatchlist = prefs.getString('watchlist');
    if (storedWatchlist != null) {
      _watchlist =
          List<Map<String, dynamic>>.from(json.decode(storedWatchlist));
      notifyListeners();
    }
  }
}
