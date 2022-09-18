class Exercise {
  final dynamic id;
  final String title;
  final String reps;
  final int sets;
  final int rest;
  final String note;
  final List<List<double>> weights;
  final List<String> record;

  Exercise({
    this.id,
    required this.title,
    required this.reps,
    required this.sets,
    required this.rest,
    required this.note,
    required this.weights,
    required this.record,
  });
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['_id'],
      title: json['title'],
      reps: json['reps'],
      sets: json['sets'],
      rest: json['rest'],
      note: json['note'],
      weights: json['weights'] != null
          ? List<List<double>>.from(json['weights']
              .map((weightList) => List<double>.from(
                  weightList.map((weight) => weight.toDouble()).toList()))
              .toList())
          : [],
      record: json['record'] != null ? List<String>.from(json['record']) : [],
    );
  }
  toJson() {
    if (id != null) {
      return {
        '_id': id,
        'title': title,
        'reps': reps,
        'sets': sets,
        'rest': rest,
        'note': note,
        'weights': weights,
        'record': record,
      };
    }
    return {
      'title': title,
      'reps': reps,
      'sets': sets,
      'rest': rest,
      'note': note,
      'weights': weights,
      'record': record,
    };
  }
}
