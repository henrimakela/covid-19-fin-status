class RecoveredCase{

  int id;
  DateTime date;
  String healthCareDistrict;

  RecoveredCase({this.id, this.date, this.healthCareDistrict});

  factory RecoveredCase.fromJson(Map<String, dynamic> json){
    return RecoveredCase(
      id: json['id'],
      date: DateTime.parse(json['date']),
      healthCareDistrict: json['healthCareDistrict']
    );
  }
}