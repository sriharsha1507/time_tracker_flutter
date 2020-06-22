import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:timetrackerfluttercourse/app/home/models/job.dart';
import 'package:timetrackerfluttercourse/services/api_path.dart';
import 'package:timetrackerfluttercourse/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);

  Stream<List<Job>> jobsStream();
}

class FirestoreDatabase extends Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final FirestoreService _service = FirestoreService.instance;

  @override
  Future<void> createJob(Job job) async {
    final path = ApiPath.job(uid, 'job_abc');
    _service.setData(
      path: path,
      data: job.toMap(),
    );
  }

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: ApiPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );
}
