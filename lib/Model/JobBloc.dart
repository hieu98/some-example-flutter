import 'dart:async';
import 'package:flutter_app/Database/DBProvider.dart';
import 'package:flutter_app/Model/JobModel.dart';

class JobBloc{
  JobBloc(){
    getJobs();
  }

  final _jobController = StreamController<List<Job>>.broadcast();
  get jobs => _jobController.stream;

  dispose(){
    _jobController.close();
  }

  getJobs() async {
    _jobController.sink.add(await DBProvider.db.getAllJob());
  }

  delete(int id){
    DBProvider.db.deleteJob(id);
    getJobs();
  }

  add(Job job) async{
    await DBProvider.db.newJob(job);
    getJobs();
  }

  check(Job job) {
    DBProvider.db.checkJob(job);
    getJobs();
  }

  deleteCheck() async{
    var list = await DBProvider.db.getListCheck() as List<Job>?;
    for (var element in list!) {
      await DBProvider.db.deleteJob(element.id!);
    }
    getJobs();
  }
}