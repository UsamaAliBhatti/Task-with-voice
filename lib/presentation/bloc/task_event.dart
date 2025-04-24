part of 'task_bloc.dart';

class TaskEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateTaskEvent extends TaskEvent {
  final Task task;

  CreateTaskEvent({required this.task});
}

class ListeningSpeechEvent extends TaskEvent {
  final bool isListening;
  ListeningSpeechEvent({required this.isListening});
}

class UpdateTextEvent extends TaskEvent {
  final String text;
  UpdateTextEvent({required this.text});
}
