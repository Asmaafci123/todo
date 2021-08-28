import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/shared/components.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        builder: (context,state)
        {
          var tasks=AppCubit.get(context).archivedTasks;
          return ListView.separated(
              itemBuilder: (context,index)=>buildTaskItem(
                  time: tasks[index]['time'],
                  title: tasks[index]['title'],
                  date: tasks[index]['date'],
                  id: index,
                  context: context),
              separatorBuilder: (context,index)=>Container(
                  height: 1.0,
                  width: double.infinity,
                  color: Colors.grey
              ),
              itemCount:tasks.length);
        },
        listener: (context,state){}
    );
  }
}
