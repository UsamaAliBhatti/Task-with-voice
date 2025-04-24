import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:task_voice/data/data_src/data_src.dart';
import 'package:task_voice/data/models/task_model.dart';
import 'package:task_voice/enums.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final SpeechToText _speechToText = SpeechToText();
  final db = DataSrc("AIzaSyBXQiEi3jWmXfwNO3Gn81NF0gUtAsfYCc4");

  TaskBloc() : super(TaskState()) {
    on<ListeningSpeechEvent>(_onStartListenSpeech);
    on<UpdateTextEvent>(_onUpdateText);
  }
  _onUpdateText(UpdateTextEvent event, Emitter<TaskState> emit) {
    emit(state.copyWith(extractedText: event.text));
  }

  _onStartListenSpeech(
      ListeningSpeechEvent event, Emitter<TaskState> emit) async {
    print(event.isListening.toString());
    if (event.isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (status) {
          if (status == 'notListening') {
            add(ListeningSpeechEvent(isListening: false));
          }
        },
        onError: (error) {
          add(ListeningSpeechEvent(isListening: false));
        },
      );

      if (available) {
        await _speechToText.listen(
          onResult: (result) {
            add(UpdateTextEvent(text: result.recognizedWords));
          },
          pauseFor: const Duration(seconds: 5),
          listenOptions: SpeechListenOptions(
            listenMode: ListenMode.dictation,
            partialResults: true,
          ),
        );
        emit(state.copyWith(isListening: event.isListening));
      }
    } else {
      if (_speechToText.isListening) {
        await _speechToText.stop();
      }
      emit(state.copyWith(isListening: false));
      if (state.extractedText.trim().isNotEmpty) {
        final result = await db.parseCommand(state.extractedText);

        _handleParsedCommand(result, emit);
      }
    }
  }

  void _handleParsedCommand(Task task, Emitter<TaskState> emit) {
    if (task.action == 'create') {
      final updatedTasks = List<Task>.from(state.tasks)..add(task);
      emit(state.copyWith(tasks: updatedTasks));
    } else if (task.action == 'delete') {
      print("coming here");
      final List<Task> tasks = List.from(state.tasks);
      tasks.removeWhere((t) => t.title.trim() == task.title.trim());

      emit(state.copyWith(tasks: tasks));
    } else if (task.action == 'update') {
      final updatedTasks = state.tasks.map((t) {
        if (t.title == task.title) {
          return task;
        }
        return t;
      }).toList();
      emit(state.copyWith(tasks: updatedTasks));
      // String convertTo24Hour(String time) {
      //   final dateTime = DateTime.parse("2020-01-01 ${time.trim()}");
      //   return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
      // }
    }
  }
}
