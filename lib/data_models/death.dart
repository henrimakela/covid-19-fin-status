class Death{

  String date;
  String healthCareDistrict;

  Death({this.date, this.healthCareDistrict});

  factory Death.fromJson(Map<String, dynamic> json){
    return Death(
        date: json['date'],
        healthCareDistrict: json['healthCareDistrict']
    );
  }
}