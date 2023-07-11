import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/states.dart';

import 'cubit.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,states){},
      builder: (context,states){

        var tasks = AppCubit.get(context).tasks;

        return ListView.separated(
          itemBuilder: (context,index)=> Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  child: Text(
                    '${tasks[index]['time']}',
                  ),
                ),
                SizedBox(width: 20,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${tasks[index]['title']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '${tasks[index]['date']}',
                      style: TextStyle(
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          itemCount: tasks.length,
          separatorBuilder: (context,index)=> Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
        );

      },
    );
  }

}
