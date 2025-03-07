class sensor {
  String? message;
  double? current;
  double? voltage;
  String? sendDateTime;
  double? light1;
  double? light2;
  double? light3;
  double? temperature;
  double? humidity;

  sensor({
    this.message,
    this.current,
    this.voltage,
    this.sendDateTime,
    this.light1,
    this.light2,
    this.light3,
    this.temperature,
    this.humidity,
  });

  factory sensor.fromJson(Map<String, dynamic> json) {
    return sensor(
      message: json['message'],
      current: (json['current'] as num?)?.toDouble(),
      voltage: (json['voltage'] as num?)?.toDouble(),
      sendDateTime: json['sendDateTime'],
      light1: (json['Light1'] as num?)?.toDouble(),
      light2: (json['Light2'] as num?)?.toDouble(),
      light3: (json['Light3'] as num?)?.toDouble(),
      temperature: (json['Temperature'] as num?)?.toDouble(),
      humidity: (json['Humidity'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'current': current,
      'voltage': voltage,
      'SendDateTime': sendDateTime,
      'Light1': light1,
      'Light2': light2,
      'Light3': light3,
      'Temperature': temperature,
      'Humidity': humidity,
    };
  }
}
