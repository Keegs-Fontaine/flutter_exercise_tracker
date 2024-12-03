import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:provider/provider.dart';
import 'package:tracker_testing_app/util/exercise.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeightTrackerNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const primaryBgColor = Color.fromRGBO(226, 79, 79, 1);
  static const primaryTxtColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBgColor,
          title: const Text(
            "Flutter Weights Tracker",
            style:
                TextStyle(color: primaryTxtColor, fontWeight: FontWeight.bold),
          ),
        ),
        body: const Center(
          child: Home(),
        ),
      ),
    );
  }
}

class WeightTrackerNotifier extends ChangeNotifier {
  final _exercises = ExerciseList();

  void append(TrackedExercise exercise) {
    _exercises.addNewExercise(exercise);

    notifyListeners();
  }

  void clearFinishedExercises() {
    _exercises.removeFinishedExercises();

    notifyListeners();
  }
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExerciseSelector(),
        const WeightsList(),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Clear Finished Exercises"),
        )
      ],
    );
  }
}

class WeightsList extends StatefulWidget {
  const WeightsList({super.key});

  @override
  State<WeightsList> createState() => _WeightsListState();
}

class _WeightsListState extends State<WeightsList> {
  void set() {
    widget.exerciseList.addNewExercise(
      TrackedExercise(
        name: "Bench Press",
        weight: 185,
        exerciseType: ExerciseType.push,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    set();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (TrackedExercise exercise in widget.exerciseList)
          CheckboxListTile(
            title: Text(exercise.name),
            value: exercise.isFinished,
            onChanged: (bool? value) {
              setState(() {
                exercise.isFinished = value ?? true;
              });
            },
          ),
      ],
    );
  }
}

class ExerciseSelector extends StatefulWidget {
  const ExerciseSelector({super.key});

  @override
  State<ExerciseSelector> createState() => _ExerciseSelectorState();
}

class _ExerciseSelectorState extends State<ExerciseSelector> {
  final _cont = TextEditingController();

  final WeightTrackerNotifier COU = WeightTrackerNotifier();

  void _addNewListItem() {
    final newExerciseName = _cont.text;

    setState(() {
      widget.exerciseList.addNewExercise(
        TrackedExercise(
          name: newExerciseName,
          weight: 100,
          exerciseType: ExerciseType.pull,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _cont,
        ),
        Consumer<WeightTrackerNotifier>(
          builder: (context, value, child) => ElevatedButton(
            onPressed: value.add,
            child: Text(
              value._count.toString(),
            ),
          ),
        )
      ],
    );
  }
}
