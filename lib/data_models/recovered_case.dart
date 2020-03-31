class RecoveredCase{

  DateTime date;
  String healthCareDistrict;

  RecoveredCase({this.date, this.healthCareDistrict});

  factory RecoveredCase.fromJson(Map<String, dynamic> json){
    return RecoveredCase(
      date: DateTime.parse(json['date']),
      healthCareDistrict: json['healthCareDistrict']
    );
  }
}