import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:provider/provider.dart';
import 'package:tracker_testing_app/util/exercise.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeightsModel(),
      child: const MyApp(),
    ),
  );
}

class WeightsModel extends ChangeNotifier {
  final _exercises = ExerciseList();

  WeightsModel() {
    _exercises.addNewExercise(
      TrackedExercise(
        name: "Bench",
        weight: 185,
        exerciseType: ExerciseType.push,
      ),
    );
  }

  get exercises => _exercises;

  void append(TrackedExercise exercise) {
    _exercises.addNewExercise(exercise);

    notifyListeners();
  }

  void clearFinishedExercises() {
    _exercises.removeFinishedExercises();

    print(_exercises);

    notifyListeners();
  }
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

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _exerciseState = WeightsModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExerciseSelector(),
        const WeightsList(),
        ElevatedButton(
          onPressed: () => _exerciseState.clearFinishedExercises(),
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
  final _exerciseState = WeightsModel();

  void set() {}

  @override
  void initState() {
    super.initState();
    set();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _exerciseState,
      builder: (BuildContext context, Widget? child) {
        final exercises = _exerciseState.exercises;
        print("FROM BUILDER");
        print(exercises);

        return Column(
          children: [
            for (TrackedExercise exercise in exercises) Text(exercise.name)
          ],
        );
      },
    );
  }
}

class ExerciseSelector extends StatefulWidget {
  const ExerciseSelector({super.key});

  @override
  State<ExerciseSelector> createState() => _ExerciseSelectorState();
}

class _ExerciseSelectorState extends State<ExerciseSelector> {
  final _exerciseState = WeightsModel();
  final _cont = TextEditingController();

  void _addNewListItem(TrackedExercise exercise) {
    _exerciseState.append(exercise);
    print("fuck");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _cont,
        ),
      ],
    );
  }
}
