import 'dart:convert';
import 'package:covid_19_fin_status/data_models/death.dart';
import 'package:http/http.dart' as http;
import 'package:covid_19_fin_status/cache/database_helper.dart';
import 'package:covid_19_fin_status/data_models/confirmed_case.dart';
import 'package:covid_19_fin_status/data_models/corona_response.dart';
import 'package:covid_19_fin_status/data_models/recovered_case.dart';
import 'package:covid_19_fin_status/network/corona_api_client.dart';

class CoronaRepository {
  DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<http.Response> fetchCoronaFromTheApi() async {
    var response = await CoronaApiClient.fetchCorona();
    return response;
  }

  CoronaResponse _parseJson(String response) {
    Map<String, dynamic> json = jsonDecode(response);

    List<ConfirmedCase> confirmedCases = List();
    List<RecoveredCase> recoveredCases = List();
    List<Death> deathCases = List();

    for (int i = 0; i < json['confirmed'].length; i++) {
      confirmedCases.add(ConfirmedCase.fromJson(json['confirmed'][i]));
    }

    for (int i = 0; i < json['recovered'].length; i++) {
      recoveredCases.add(RecoveredCase.fromJson(json['recovered'][i]));
    }

    for (int i = 0; i < json['deaths'].length; i++) {
      deathCases.add(Death.fromJson(json['deaths'][i]));
    }

    return CoronaResponse(
        confirmedCases: confirmedCases,
        recoveredCases: recoveredCases,
        deathCases: deathCases);
  }

  Future<CoronaResponse> getCoronaData() async {
    //CACHING HERE

    bool cacheIsClear = await _databaseHelper.cacheIsClear();

    if (cacheIsClear) {
      print("CoronaRepository: cache is clear. fetch new data");
      var response = await fetchCoronaFromTheApi();
      await _databaseHelper.insertCache(response.body.toString());

    } else {
      bool cacheIsOld = await _databaseHelper.cacheIsOld();
      if (cacheIsOld) {
        print("CoronaRepository: cache is too old. fetch fresh data");
        fetchCoronaFromTheApi().then((response) {
          _databaseHelper.insertCache(response.body);
        });
      }
    }

    var json = await _databaseHelper.getCache();
    return _parseJson(json);
  }
}
