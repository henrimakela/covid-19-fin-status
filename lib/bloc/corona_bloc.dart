

import 'package:covid_19_fin_status/data_models/confirmed_case.dart';
import 'package:covid_19_fin_status/data_models/death.dart';
import 'package:covid_19_fin_status/data_models/recovered_case.dart';
import 'package:covid_19_fin_status/repository/corona_repository.dart';
import 'package:rxdart/rxdart.dart';

class CoronaBloc{

  CoronaRepository repository;


  final _confirmedCasesController = BehaviorSubject<List<ConfirmedCase>>();
  final _recoveredCasesController = BehaviorSubject<List<RecoveredCase>>();
  final _deathController = BehaviorSubject<List<Death>>();

  Stream<List<ConfirmedCase>> get confirmedStream => _confirmedCasesController.stream;
  Stream<List<RecoveredCase>> get recoveredStream => _recoveredCasesController.stream;
  Stream<List<Death>> get deathStream => _deathController.stream;


  CoronaBloc({this.repository}){
    _fetchDataFromRepository();
  }

  _fetchDataFromRepository(){
    repository.getCoronaData().then((data){

      data.confirmedCases.sort((a, b){
        return b.date.compareTo(a.date);
      });

      data.recoveredCases.sort((a,b){
        return b.date.compareTo(a.date);
      });

      data.deathCases.sort((a,b){
        return b.date.compareTo(a.date);
      });

      _confirmedCasesController.sink.add(data.confirmedCases);
      _recoveredCasesController.sink.add(data.recoveredCases);
      _deathController.sink.add(data.deathCases);
    });
  }

  dispose(){
    _recoveredCasesController.close();
    _confirmedCasesController.close();
    _deathController.close();
  }

}