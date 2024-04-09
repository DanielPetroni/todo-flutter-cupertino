import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:todocupertino/src/controller/tasks_controller.dart';

class CreateTaskWidget extends StatefulWidget {
  const CreateTaskWidget({super.key, required this.tasksController});
  final TasksController tasksController;

  @override
  State<CreateTaskWidget> createState() => _CreateTaskWidgetState();
}

class _CreateTaskWidgetState extends State<CreateTaskWidget> {
  final TextEditingController textEditingControllerTitle = TextEditingController();
  final TextEditingController textEditingControllerDate = TextEditingController();
  final GlobalKey<FormState> globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    DateTime? dateTimeSelected;
    showCupertinoDate() {
      showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: SafeArea(
            top: false,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              mode: CupertinoDatePickerMode.date,
              use24hFormat: true,
              showDayOfWeek: true,
              onDateTimeChanged: (DateTime newDate) {
                dateTimeSelected = newDate;
                textEditingControllerDate.text = DateFormat.yMMMd().format(newDate);
              },
            ),
          ),
        ),
      );
    }

    return CupertinoDialogAction(
      child: Container(
        decoration:
            const BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: globalKey,
            child: ValueListenableBuilder(
              valueListenable: widget.tasksController,
              builder: (context, tasksState, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("New task", style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle),
                      const Spacer(),
                      CupertinoButton(child: const Icon(CupertinoIcons.clear), onPressed: () => context.pop())
                    ],
                  ),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    placeholder: 'Titulo',
                    controller: textEditingControllerTitle,
                  ),
                  tasksState.textFieldTitleError.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            tasksState.textFieldTitleError,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .tabLabelTextStyle
                                .copyWith(color: CupertinoColors.systemRed),
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 10),
                  CupertinoTextField(
                    placeholder: 'Data',
                    enabled: true,
                    controller: textEditingControllerDate,
                    onTap: showCupertinoDate,
                  ),
                  tasksState.textFieldDateerror.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            tasksState.textFieldDateerror,
                            style: CupertinoTheme.of(context)
                                .textTheme
                                .tabLabelTextStyle
                                .copyWith(color: CupertinoColors.systemRed),
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  Center(
                    child: CupertinoButton.filled(
                      child: const Text('Save'),
                      onPressed: () {
                        widget.tasksController.createNewTask(
                          textEditingControllerTitle.text,
                          dateTimeSelected,
                          () {
                            context.pop();
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
