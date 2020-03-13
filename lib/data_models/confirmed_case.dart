class ConfirmedCase {
  String id;
  DateTime date;
  String healthCareDistrict;
  String infectionSourceCountry;

  ConfirmedCase({
    this.id,
    this.date,
    this.healthCareDistrict,
    this.infectionSourceCountry,
  });

  factory ConfirmedCase.fromJson(Map<String, dynamic> json) {
    return ConfirmedCase(
      id: json['id'],
      date: DateTime.parse(json['date']),
      healthCareDistrict: json['healthCareDistrict'],
      infectionSourceCountry: json['infectionSourceCountry'],
    );
  }
}
