import 'package:flutter/material.dart';
import 'cubit/cubit.dart';
Widget defaultTextField(
{
  required TextEditingController? controller,
  required TextInputType? type,
  Function? onChange,
  Function? onTap,
  Function? validate,
  String? label,
  IconData? prefix,
  bool isClickable=true,
})
{
  return TextFormField(
  controller: controller,
    keyboardType:type ,
    onChanged:(s){
      onChange!();
    },
    onTap: (){
      onTap!();
    },

    enabled: isClickable,
    decoration: InputDecoration(
      //icon: Icon(prefix!),
      prefixIcon: Icon(prefix!),
      label: Text(label!),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10)
      )
    ),
    validator:(s)
    {
      validate!();
    },
  );
}
Widget buildTaskItem({
  required String time,
  required String title,
  required String date,
  required int id,
  required BuildContext context
})
{
  return Dismissible(
    key: UniqueKey(),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children:[
          CircleAvatar(
            child: Text(time),
            radius: 40,
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    title,
                style: const TextStyle(
                  fontSize: 20
                ),),
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.grey
                  ),),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: ()async{
                 AppCubit.get(context).
                update(status: 'done', id: id);
                // print('pressed');
              },
              icon: const Icon(Icons.check_circle,color: Colors.blue,)),
          const SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: ()async{
                AppCubit.get(context).
                update(status: 'archived', id: id);
              },
              icon: const Icon(Icons.archive_outlined,color: Colors.grey,)),
        ],
      ),
    ),
    onDismissed: (direction){
      AppCubit.get(context).delete(id: id);
    },
  );
}