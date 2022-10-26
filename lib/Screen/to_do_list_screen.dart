import 'package:flutter/material.dart';
import 'package:flutter_app/Database/DBProvider.dart';
import 'package:flutter_app/Model/JobModel.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {

  late Job job = Job();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('To do list'),
            actions: [
              IconButton(
                  onPressed: () async {
                    var list = await DBProvider.db.getListCheck();
                    for (var element in list!) {
                      await DBProvider.db.deleteJob(element.id!);
                    }
                    setState(() {});
                  },
                  icon: Icon(Icons.delete)
              )
            ],
          ),
          body: FutureBuilder<List<Job>>(
              future: DBProvider.db.getAllJob(),
              builder: (context, AsyncSnapshot<List<Job>> snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index){
                        Job item = snapshot.data![index];
                        return Dismissible(
                            key: UniqueKey(),
                            background: Container(color: Colors.red,),
                            onDismissed: (direction) {
                              DBProvider.db.deleteJob(item.id!);
                            },
                            child: ItemListView(job: item,)
                        );
                      }
                  );
                }else{
                  return Center();
                }
              },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(context: context, builder: (context){
                return Center(
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 15),
                              child: Text(
                                'New Job',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(20),
                              child: TextField(
                                autofocus: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (text){
                                  job.jobName = text;
                                  setState(() {});
                                },
                              ),
                            ),
                            ElevatedButton(onPressed: () async {
                                await DBProvider.db.newJob(job);
                                setState(() {
                                  Navigator.of(context, rootNavigator: true).pop();
                                });
                              }, child: Text('Ok'))
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
            },
            child: Icon(Icons.add),
          ),
      )
    );
  }
}

class ItemListView extends StatefulWidget {
  final Job job;
  ItemListView({Key? key, required this.job}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemListView(job);
}

class _ItemListView extends State<ItemListView> {
  final Job job;

  _ItemListView(this.job);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      color: job.isChecked == 0 ? Colors.white : Colors.blue[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            job.jobName!,
            textAlign: TextAlign.start,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17, ),
          ),
          Checkbox(
              value: job.isChecked == 0 ? false: true,
              onChanged: (value) async {
                job.isChecked = value == false ? 0 : 1;
                await DBProvider.db.checkJob(job);
                setState(() {});
              }
          )
        ],
      ),
    );
  }
}

