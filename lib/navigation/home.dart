import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:spons/l10n/my_localization.dart';

import 'package:spons/leftnav.dart';

import '../detailpage/DetailMovie.dart';

class HomeList extends StatefulWidget {
  const HomeList({super.key});

  @override
  State<HomeList> createState() => _HomeListState();
}

class _HomeListState extends State<HomeList> {
  double kSpacing = 14.00;
  BorderRadius kBorderRadius = BorderRadius.circular(20.00);

  late Stream<List<Map<String, dynamic>>> _trendings;
  late Stream<List<Map<String, dynamic>>> _movies;
  late Stream<List<Map<String, dynamic>>> _nowPlaying;

  InterstitialAd? _interstitialAd;

  bool _isInterstitialReady = false;

  @override
  void initState() {
    super.initState();
    _trendings = getTrending().asBroadcastStream();
    _movies = getMovies().asBroadcastStream();

    _nowPlaying = getNowPlaying().asBroadcastStream();
    _loadInterstitialAd(context);
  }

  void _loadInterstitialAd(BuildContext context,
      [Map<String, dynamic>? movie, Function? onAdReady]) {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                if (movie != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailMovies(
                        movie: movie,
                      ),
                    ),
                  );
                }
              },
            );
            _isInterstitialReady = true;
            _interstitialAd = ad;
            if (onAdReady != null) {
              onAdReady();
            }
          },
          onAdFailedToLoad: (err) {
            _isInterstitialReady = false;
            _interstitialAd?.dispose();
          },
        ));
  }

  Stream<List<Map<String, dynamic>>> getTrending() {
    return Stream.fromFuture(_fetchTrending());
  }

  Future<List<Map<String, dynamic>>> _fetchTrending() async {
    try {
      var response = await Dio().get(
          "https://api.themoviedb.org/3/trending/movie/day?api_key=6e6c2ac305876492f99cc067787a39a0");
      var dataset = response.data['results'];
      return List<Map<String, dynamic>>.from(dataset).take(5).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> getMovies() {
    return Stream.fromFuture(_fetchMovies());
  }

  Future<List<Map<String, dynamic>>> _fetchMovies() async {
    try {
      var response = await Dio().get(
          "https://api.themoviedb.org/3/movie/popular?api_key=6e6c2ac305876492f99cc067787a39a0");
      var data = response.data['results'];
      return List<Map<String, dynamic>>.from(data).take(10).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> getNowPlaying() {
    return Stream.fromFuture(_fetchNowPlaying());
  }

  Future<List<Map<String, dynamic>>> _fetchNowPlaying() async {
    try {
      var response = await Dio().get(
          "https://api.themoviedb.org/3/movie/now_playing?api_key=6e6c2ac305876492f99cc067787a39a0");
      var nowplaying = response.data["results"];
      return List<Map<String, dynamic>>.from(nowplaying).take(6).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              left: 15,
              top: 20,
            ),
            child: Text(MyLocalization.of(context)!.trending,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 290.0,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _trendings,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          width: 130.0,
                          child: Card(
                            elevation: 20,
                            child: InkWell(
                              onTap: () {
                                if (_isInterstitialReady = false) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DetailMovies(
                                                movie: snapshot.data![index],
                                              )));
                                } else {
                                  _loadInterstitialAd(
                                      context, snapshot.data![index], () {
                                    if (_isInterstitialReady) {
                                      _interstitialAd?.show();
                                    }
                                  });
                                }
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(kSpacing)),
                                    child: Image.network(
                                        'http://image.tmdb.org/t/p/w500/${snapshot.data![index]['poster_path']}'),
                                  ),
                                  Text(
                                    '${snapshot.data![index]['original_title']}',
                                    style: TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('API sedang bermasalah');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          //
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 5,
            ),
            child: Text(MyLocalization.of(context)!.recommended,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          ),
        ),

        StreamBuilder<List<Map<String, dynamic>>>(
          stream: _movies,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 2, //width / height
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Padding(
                        padding: EdgeInsets.only(
                            left: 12, bottom: 12, right: 12, top: 11),
                        child: Card(
                          elevation: 10,
                          color: Color.fromARGB(255, 23, 24, 28),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailMovies(
                                            movie: snapshot.data![index],
                                          )));
                            },
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(kSpacing)),
                                  child: Image.network(
                                      'http://image.tmdb.org/t/p/w500/${snapshot.data![index]['poster_path']}'),
                                ),
                                Text(
                                  '${snapshot.data![index]['original_title']}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ));
                  },
                  childCount: snapshot.data?.length,
                ),
              );
            } else if (snapshot.hasError) {
              return SliverFillRemaining(child: Text('API dalam masalah'));
            } else {
              return SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()));
            }
          },
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
              left: 15,
              bottom: 5,
            ),
            child: Text(MyLocalization.of(context)!.nowPlaying,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 200.0,
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _nowPlaying,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          width: 260.0,
                          child: Card(
                            elevation: 20,
                            child: InkWell(
                              onTap: () {
                                _loadInterstitialAd(
                                    context, snapshot.data![index], () {
                                  if (_isInterstitialReady) {
                                    _interstitialAd?.show();
                                  }
                                });
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(kSpacing)),
                                    child: Image.network(
                                        'http://image.tmdb.org/t/p/w500/${snapshot.data![index]['backdrop_path']}'),
                                  ),
                                  Text(
                                    '${snapshot.data![index]['original_title']}',
                                    style: TextStyle(fontSize: 13),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error fetching data');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
        //New column
      ],
    ));
  }
}
