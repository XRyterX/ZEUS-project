import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spons/detailpage/DetailMovie.dart';
import 'package:spons/l10n/my_localization.dart';
import 'package:spons/leftnav.dart';

import '../provider/watchlist_provider.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({super.key});

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  double kSpacing = 14.00;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<WatchlistProvider>(context);
    return Scaffold(
      body: prov.watchlist.isEmpty
          ? Center(
              child: Text(
              MyLocalization.of(context)!.descWatchlist,
              textAlign: TextAlign.center,
            ))
          : CustomScrollView(
              slivers: <Widget>[
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 2,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Card(
                          color: Color.fromARGB(255, 23, 24, 28),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailMovies(
                                    movie: prov.watchlist[index],
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(kSpacing)),
                                  child: prov.watchlist[index]['poster_path'] !=
                                          null
                                      ? Image.network(
                                          'http://image.tmdb.org/t/p/w500/${prov.watchlist[index]['poster_path']}',
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                                'assets/not_available.png');
                                          },
                                        )
                                      : Image.asset('assets/not_available.png'),
                                ),
                                Text(
                                  '${prov.watchlist[index]['original_title']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '${prov.watchlist[index]['release_date']}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: prov.watchlist.length,
                  ),
                ),
              ],
            ),
    );
  }
}
