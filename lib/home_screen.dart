import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/cubit.dart';
import 'package:to_do_app/states.dart';


class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);


  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController TitleController = TextEditingController();
  TextEditingController TimeController = TextEditingController();
  TextEditingController DateController = TextEditingController();

  @override
  Widget build(BuildContext context) {



    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, state) {
          if(state is AppInsertToDataBaseState){
            Navigator.pop(context);
          }
        },
        builder: (context, state) {

          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Center(
                child: Text('Tasks'),
              ),
            ),
            body: state is! AppGetFromDataBaseLoadingState ? Center(child: CircularProgressIndicator(),) : cubit.screens[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (!cubit.isBottomSheetShown) {
                  cubit.insertToDataBase(
                    title: TitleController.text,
                    time: TimeController.text,
                    date: DateController.text,
                  ).then(
                    (value) {
                      cubit.getDataFromDataBase(cubit.database).then((value) {
                        cubit.tasks = value;
                      });

                    },
                  );
                } else {
                  scaffoldKey.currentState!.showBottomSheet(
                        (context) => Container(
                          color: Colors.grey[200],
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: TitleController,
                                decoration: InputDecoration(
                                  hintText: 'Title',
                                  prefixIcon: Icon(
                                    Icons.title,
                                  ),
                                ),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: () {
                                  showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  ).then(
                                    (value) {
                                      TimeController.text =
                                          value!.format(context);
                                    },
                                  );
                                },
                                controller: TimeController,
                                decoration: InputDecoration(
                                  hintText: 'Time',
                                  prefixIcon: Icon(
                                    Icons.access_time,
                                  ),
                                ),
                              ),
                              TextFormField(
                                readOnly: true,
                                onTap: () {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.parse('2030-12-12'),
                                  ).then(
                                    (value) {
                                      DateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    },
                                  );
                                },
                                controller: DateController,
                                decoration: InputDecoration(
                                  hintText: 'Time',
                                  prefixIcon: Icon(
                                    Icons.access_time,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).closed.then((value) {
                        cubit.changeBottomSheet(isShown: true, icon: Icons.edit);
                      });
                  cubit.changeBottomSheet(isShown: false, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fapIcon,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}
