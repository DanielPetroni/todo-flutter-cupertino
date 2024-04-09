import 'package:flutter/cupertino.dart';
import 'package:todocupertino/src/controller/tasks_controller.dart';
import 'package:todocupertino/src/widgets/create_task_widget.dart';

class TasksPages extends StatefulWidget {
  const TasksPages({super.key});

  @override
  State<TasksPages> createState() => _TasksPagesState();
}

class _TasksPagesState extends State<TasksPages> {
  final TasksController tasksController = TasksController();

  @override
  void initState() {
    tasksController.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your tasks",
                  style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder(
                  valueListenable: tasksController,
                  builder: (context, taskState, child) => taskState.isLoading
                      ? const Center(child: CupertinoActivityIndicator())
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: taskState.tasks.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key('dimissibleKey$index'),
                              background: const Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(CupertinoIcons.delete),
                                ],
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) => tasksController.deleteTask(index),
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      color: CupertinoColors.extraLightBackgroundGray),
                                  child: CupertinoListTile(
                                    title: Text(
                                      taskState.tasks[index].title,
                                      style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
                                    ),
                                    subtitle: Text(
                                      '${taskState.tasks[index].dateTime.day.toString().padLeft(2, '0')}/${taskState.tasks[index].dateTime.month.toString().padLeft(2, '0')}/${taskState.tasks[index].dateTime.year}',
                                    ),
                                    trailing: CupertinoCheckbox(
                                      value: taskState.tasks[index].complete,
                                      onChanged: (value) => tasksController.changeStatusTask(index, value),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CupertinoButton.filled(
                child: const Text("New"),
                onPressed: () {
                  showCupertinoDialog(
                          context: context, builder: (context) => CreateTaskWidget(tasksController: tasksController))
                      .then((value) => tasksController.disposeCreatePage());
                },
              ),
            )
          ],
        ),
      ),
    ));
  }
}
