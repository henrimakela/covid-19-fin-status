import 'package:covid_19_fin_status/data_models/confirmed_case.dart';
import 'package:covid_19_fin_status/data_models/death.dart';
import 'package:covid_19_fin_status/data_models/recovered_case.dart';

class CoronaResponse {

  List<ConfirmedCase> confirmedCases;
  List<RecoveredCase> recoveredCases;
  List<Death> deathCases;

  CoronaResponse({this.confirmedCases, this.recoveredCases, this.deathCases});
}
