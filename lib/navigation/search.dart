import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:spons/l10n/my_localization.dart';

import '../detailpage/DetailMovie.dart';

class appSearch extends StatefulWidget {
  appSearch({Key? key}) : super(key: key);

  @override
  State<appSearch> createState() => _appSearchState();
}

class _appSearchState extends State<appSearch> {
  late TextEditingController controller = TextEditingController();
  String searchString = "";
  double minRating = 0.0;
  int startYear = 0;
  int endYear = DateTime.now().year; // default to current year
  late Stream<List<dynamic>> searchData;

  Future<List<dynamic>> fetchData() async {
    final response = await Dio().get(
        'https://api.themoviedb.org/3/search/movie?query=$searchString&api_key=6e6c2ac305876492f99cc067787a39a0');
    if (response.statusCode == 200) {
      return response.data['results'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<dynamic> filterData(List<dynamic> data) {
    return data
        .where((item) =>
            item['title'].contains(searchString) &&
            item['vote_average'] >= minRating &&
            (startYear == 0 || int.parse(item['release_date'].substring(0, 4)) >= startYear) &&
            (endYear == 0 || int.parse(item['release_date'].substring(0, 4)) <= endYear))
        .toList();
  }

  @override
  void initState() {
    super.initState();

    searchString = "";
    searchData = fetchData().asStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: EdgeInsets.all(16.0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    TextField(
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        setState(() {
                          searchString = value;
                          searchData = fetchData().asStream();
                        });
                      },
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: MyLocalization.of(context)!.search,
                        prefixIcon: Icon(Icons.search),
                        hintText: "Oppenheimer",
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text("Filter by Rating"),
                    Slider(
                      value: minRating,
                      min: 0.0,
                      max: 10.0,
                      divisions: 100,
                      label: minRating.toString(),
                      onChanged: (value) {
                        setState(() {
                          minRating = value;
                          // Update search data when rating is changed
                          searchData = fetchData().asStream();
                        });
                      },
                    ),
                    SizedBox(height: 16.0),
                    Text("Filter by Release Year"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DropdownButton<int>(
                          value: startYear,
                          onChanged: (value) {
                            setState(() {
                              startYear = value!;
                              searchData = fetchData().asStream();
                            });
                          },
                          items: List.generate(
                            DateTime.now().year + 1,
                            (index) => DropdownMenuItem<int>(
                              value: index,
                              child: Text(index == 0 ? "All" : index.toString()),
                            ),
                          ),
                        ),
                        Text("to"),
                        DropdownButton<int>(
                          value: endYear,
                          onChanged: (value) {
                            setState(() {
                              endYear = value!;
                              searchData = fetchData().asStream();
                            });
                          },
                          items: List.generate(
                            DateTime.now().year + 1,
                            (index) => DropdownMenuItem<int>(
                              value: index,
                              child: Text(index == 0 ? "Now" : index.toString()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder<List>(
              stream: searchData,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  List? data = snapshot.data;
                  List filteredData = filterData(data!);

                  return filteredData.isEmpty
                      ? SliverFillRemaining(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                MyLocalization.of(context)!.descSearch,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int position) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailMovies(
                                        movie: filteredData[position],
                                      ),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text(filteredData[position]['title']),
                                  subtitle: Text('Release: ' +
                                      filteredData[position]['release_date'] +
                                      ' - Vote: ' +
                                      filteredData[position]['vote_average']
                                          .toString()),
                                ),
                              );
                            },
                            childCount: filteredData.length,
                          ),
                        );
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(child: Text("${snapshot.error}")),
                  );
                } else {
                  return SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
