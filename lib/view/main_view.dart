import 'dart:collection';

import 'package:covid_19_fin_status/bloc/corona_bloc.dart';
import 'package:covid_19_fin_status/data_models/confirmed_case.dart';
import 'package:covid_19_fin_status/data_models/death.dart';
import 'package:covid_19_fin_status/data_models/recovered_case.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;

  var colorMap = {0: Colors.black, 1: Colors.blueAccent, 2: Colors.redAccent};

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);

    _tabController.addListener(_setAppropriateMood);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _setAppropriateMood() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 16, bottom: 16),
        color: Colors.white,
        child: TabBar(
          controller: _tabController,
          indicatorColor: colorMap[_currentIndex],
          labelColor: colorMap[_currentIndex],
          unselectedLabelColor: Colors.grey,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.all(5.0),
          tabs: <Widget>[
            Tab(
              text: "Tartunnat",
            ),
            Tab(
              text: "Parantuneet",
            ),
            Tab(text: "Kuolleet")
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        ConfirmedCasesSliverWidget(),
        RecoveredCasesSliverWidget(),
        DeathCasesSliverWidget()
      ]),
    );
  }
}

class ConfirmedCasesSliverWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: Provider
              .of<CoronaBloc>(context)
              .confirmedStream,
          initialData: List(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {},
                      )
                    ],
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 32,
                              ),
                              onPressed: () {
                                _showOverViewDialog(snapshot.data, context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    floating: false,
                    pinned: false,
                    expandedHeight: 180,
                    backgroundColor: Colors.black,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Tartunnan saaneita",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            snapshot.data.length.toString(),
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        ConfirmedCase confirmedCase = snapshot.data[index];
                        return ListTile(
                          title: Text(confirmedCase.healthCareDistrict == null
                              ? ""
                              : confirmedCase.healthCareDistrict),
                          subtitle: Text(confirmedCase.date == null
                              ? ""
                              : "${confirmedCase.date.day}.${confirmedCase.date
                              .month}.${confirmedCase.date.year}"),
                          trailing: Text(
                              confirmedCase.infectionSourceCountry == null
                                  ? ""
                                  : confirmedCase.infectionSourceCountry),
                        );
                      }, childCount: snapshot.data.length))
                ],
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  _showOverViewDialog(List<ConfirmedCase> cases, BuildContext context) {
    Map<String, int> caseMap = _mapPlacesPerCases(cases);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(child: ListView(children: _mapTolistItems(caseMap)));
        });
  }

  List<Widget> _mapTolistItems(Map<String, int> map) {
    List<Widget> items = List();
    final sortedMap = SplayTreeMap.from(
        map, (a, b) => map[b].compareTo(map[a]));

    sortedMap.forEach((k, v) {
    items.add(ListTile(
    leading: Text(k),
    trailing: Text(v.toString()),
    ));
    });

    return
    items;
  }

  Map<String,int> _mapPlacesPerCases(List<ConfirmedCase> cases) {
    Map<String, int> map = Map();
    cases.forEach((c) {
      if (!map.containsKey(c.healthCareDistrict)) {
        map[c.healthCareDistrict] = 1;
      } else {
        map[c.healthCareDistrict] += 1;
      }
    });

    return map;
  }
}

class RecoveredCasesSliverWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: Provider
              .of<CoronaBloc>(context)
              .recoveredStream,
          initialData: List(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {},
                      )
                    ],
                    floating: false,
                    pinned: false,
                    expandedHeight: 180,
                    backgroundColor: Colors.blueAccent,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Parantuneita",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            snapshot.data.length.toString(),
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        RecoveredCase recoveredCase = snapshot.data[index];
                        return ListTile(
                          title: Text(recoveredCase.healthCareDistrict == null
                              ? ""
                              : recoveredCase.healthCareDistrict),
                          subtitle: Text(recoveredCase.date == null
                              ? ""
                              : "${recoveredCase.date.day}.${recoveredCase.date
                              .month}.${recoveredCase.date.year}"),
                        );
                      }, childCount: snapshot.data.length))
                ],
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

class DeathCasesSliverWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: Provider
              .of<CoronaBloc>(context)
              .deathStream,
          initialData: List(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {},
                      )
                    ],
                    floating: false,
                    pinned: false,
                    expandedHeight: 180,
                    backgroundColor: Colors.redAccent,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Kuolleita",
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                          Text(
                            snapshot.data.length.toString(),
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        Death deathCase = snapshot.data[index];
                        return ListTile(
                          title: Text(deathCase.healthCareDistrict == null
                              ? ""
                              : deathCase.healthCareDistrict),
                          subtitle:
                          Text(deathCase.date == null ? "" : deathCase.date),
                        );
                      }, childCount: snapshot.data.length))
                ],
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
