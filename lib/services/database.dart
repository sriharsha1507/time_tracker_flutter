import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:timetrackerfluttercourse/app/home/models/job.dart';
import 'package:timetrackerfluttercourse/services/api_path.dart';
import 'package:timetrackerfluttercourse/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);

  Future<void> deleteJob(Job job);

  Stream<List<Job>> jobsStream();
}

String documentIdFromCurrentData() => DateTime.now().toIso8601String();

class FirestoreDatabase extends Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final FirestoreService _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) async {
    final path = ApiPath.job(uid, job.id);
    _service.setData(
      path: path,
      data: job.toMap(),
    );
  }

  @override
  Future<Function> deleteJob(Job job) async {
    final path = ApiPath.job(uid, job.id);
    _service.deleteData(path: path);
  }

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: ApiPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );
}
