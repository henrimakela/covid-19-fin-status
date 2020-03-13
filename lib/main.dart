import 'package:covid_19_fin_status/bloc/corona_bloc.dart';
import 'package:covid_19_fin_status/repository/corona_repository.dart';
import 'package:covid_19_fin_status/view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CoronaBloc>(
          create: (context) => CoronaBloc(repository: CoronaRepository()),
          dispose: (context, value) => value.dispose(),
        ),
      ],
      child: MaterialApp(
          title: 'Corona outbreak data in Finland',
          theme: ThemeData(),
          home: MainView()),
    );
  }
}
