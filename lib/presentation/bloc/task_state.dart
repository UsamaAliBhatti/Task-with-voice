// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'task_bloc.dart';

class TaskState extends Equatable {
  final List<Task> tasks;
  final Status status;
  final bool isListening;
  final String extractedText;
  const TaskState({
    this.tasks = const [],
    this.status = Status.initial,
    this.isListening = false,
    this.extractedText = '',
  });
  @override
  List<Object?> get props => [
        tasks,
        status,
        isListening,
        extractedText,
      ];

  TaskState copyWith({
    List<Task>? tasks,
    Status? status,
    bool? isListening,
    String? extractedText,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      status: status ?? this.status,
      extractedText: extractedText ?? this.extractedText,
      isListening: isListening ?? this.isListening,
    );
  }
}
