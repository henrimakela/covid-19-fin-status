class Death{

  int id;
  String date;
  String healthCareDistrict;

  Death({this.id, this.date, this.healthCareDistrict});

  factory Death.fromJson(Map<String, dynamic> json){
    return Death(
        id: json['id'],
        date: json['date'],
        healthCareDistrict: json['healthCareDistrict']
    );
  }
}