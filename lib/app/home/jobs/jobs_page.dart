import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetrackerfluttercourse/app/home/jobs/edit_job_page.dart';
import 'package:timetrackerfluttercourse/app/home/jobs/job_list_tile.dart';
import 'package:timetrackerfluttercourse/app/home/models/job.dart';
import 'package:timetrackerfluttercourse/common_widgets/platform_alert_dialog.dart';
import 'package:timetrackerfluttercourse/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetrackerfluttercourse/services/auth.dart';
import 'package:timetrackerfluttercourse/services/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: "Logout",
      content: "Are you sure that you want to logout?",
      cancelActionText: "Cancel",
      defaultActionText: "Logout",
    ).show(context);
    if (didRequestSignOut) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 2.0,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Log out',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          )
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditJobPage.show(context),
      ),
    );
  }
}

Widget _buildContents(BuildContext context) {
  final database = Provider.of<Database>(context);
  return StreamBuilder<List<Job>>(
    stream: database.jobsStream(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final jobs = snapshot.data;
        final children = jobs
            .map((job) => JobListTile(
                  job: job,
                  onTap: () => EditJobPage.show(context, job: job),
                ))
            .toList();
        return ListView(children: children);
      }
      if (snapshot.hasError) {
        return Center(
          child: Text('There is some error'),
        );
      }
      return Center(child: CircularProgressIndicator());
    },
  );
}
