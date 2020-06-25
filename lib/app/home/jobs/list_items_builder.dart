import 'package:flutter/material.dart';
import 'package:timetrackerfluttercourse/app/home/jobs/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemWidgetBuilder,
  }) : super(key: key);

  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildContent(items);
      } else
        return EmptyContent();
      return Container();
    } else if (snapshot.hasError) {
      return EmptyContent(
          title: 'Something went wrong',
          message: 'Can\'t add items to the list');
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildContent(List<T> items) {
    return ListView.separated(
      itemCount: items.length + 2,
      separatorBuilder: (context, index) => Divider(
        height: 0.5,
      ),
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) return Container();
        return itemWidgetBuilder(context, items[index - 1]);
      },
    );
  }
}
