import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if(state is AppInsertDataBaseState)
            {
              Navigator.pop(context);
            }
        },
        builder: (BuildContext context, AppStates state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(AppCubit
                  .get(context)
                  .Titles[AppCubit
                  .get(context)
                  .currentIndex]),
            ),
            body: AppCubit
                .get(context)
                .newTasks.isEmpty
                ? Center(child: CircularProgressIndicator())
                : AppCubit
                .get(context)
                .Screens[AppCubit
                .get(context)
                .currentIndex],
            floatingActionButton: FloatingActionButton(
              child: Icon(AppCubit.get(context).toggleIcon),
              onPressed: ()
              {
                if (AppCubit.get(context).isBottomSheetShown) {
                  AppCubit.
                  get(context).
                  insertDataBase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text);

                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
                          (context) =>
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextField(
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'title must not be empty';
                                      }
                                      //return null;
                                    },
                                    controller: titleController,
                                    type: TextInputType.text,
                                    onChange: () {
                                      print('Asmaa');
                                    },
                                    onTap: () {
                                      print('Asmaa');
                                    },

                                    label: 'Task Title',
                                    prefix: Icons.title),
                                const SizedBox(
                                  height: 10,
                                ),
                                defaultTextField(
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'time must not be empty';
                                      }
                                      //return null;
                                    },
                                    controller: timeController,
                                    type: TextInputType.datetime,
                                    onChange: () {
                                      print('Asmaa');
                                    },
                                    onTap: () {
                                      showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    label: 'Task Time',
                                    prefix: Icons.watch_later_outlined),
                                const SizedBox(
                                  height: 10,
                                ),
                                defaultTextField(
                                    validate: (String value) {
                                      if (value.isEmpty) {
                                        return 'date must not be empty';
                                      }
                                      //return null;
                                    },
                                    //isClickable: false,
                                    controller: dateController,
                                    type: TextInputType.text,
                                    onChange: () {
                                      print('Asmaa');
                                    },
                                    onTap: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                          DateTime.parse('2022-02-27'))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    label: 'Task Date',
                                    prefix: Icons.calendar_today_outlined),
                              ],
                            ),
                          ),
                      elevation: 20)
                      .closed
                      .then((value) {
                    //Navigator.pop(context);
                    AppCubit.get(context).changeBottomSheetState(isShow: false, icon:Icons.edit);
                  });
                  AppCubit.get(context).changeBottomSheetState(isShow: true, icon:Icons.add);

                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: AppCubit
                  .get(context)
                  .currentIndex,
              onTap: (index) {
                AppCubit.get(context).changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archived'),
              ],
            ),
          );
        },
      ),
    );
  }


}
