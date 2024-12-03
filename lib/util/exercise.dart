enum ExerciseType { push, pull, legs }

class Exercise {
  final String name;
  final double weight;
  final ExerciseType exerciseType;

  Exercise({
    required this.name,
    required this.weight,
    required this.exerciseType,
  });
}

class TrackedExercise extends Exercise {
  bool isFinished = false;

  TrackedExercise({
    required super.name,
    required super.weight,
    required super.exerciseType,
  });
}

class ExerciseList with Iterable {
  List<TrackedExercise> _exerciseList = [];

  void addNewExercise(TrackedExercise newExercise) {
    _exerciseList.add(newExercise);

    _exerciseList = _exerciseList.toSet().toList();
  }

  void removeFinishedExercises() {
    _exerciseList = _exerciseList
        .where(
          (TrackedExercise ex) => !ex.isFinished,
        )
        .toList();
  }

  @override
  Iterator get iterator => List.unmodifiable(_exerciseList).iterator;
}
