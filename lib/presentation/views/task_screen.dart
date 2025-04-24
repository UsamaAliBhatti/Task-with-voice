import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_voice/presentation/bloc/task_bloc.dart';

class TaskScreen extends StatelessWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              print(!state.isListening);
              context
                  .read<TaskBloc>()
                  .add(ListeningSpeechEvent(isListening: !state.isListening));
            },
            child: Icon(state.isListening ? Icons.mic_off : Icons.mic),
          );
        },
      ),
      body: Container(
        child: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            return /* Text(
              state.extractedText,
              style: TextStyle(color: Colors.black),
            ); */
                ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.tasks[index].title),
                  subtitle: Text(state.tasks[index].description),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
