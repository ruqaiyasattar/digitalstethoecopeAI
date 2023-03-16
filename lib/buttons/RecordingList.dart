import 'package:flutter/material.dart';
import 'package:mboathoscope/buttons/WaveformButton.dart';
import 'package:provider/provider.dart';

import '../screens/provider/sound_provider.dart';
import '../screens/widgets/list_item.dart';

class RecordingList extends StatefulWidget {
  //final List<ListItem> items;

   RecordingList({super.key,  });
  // final List<dynamic> records;

  @override
  State<RecordingList> createState() => _RecordingListState();
}

class _RecordingListState extends State<RecordingList> {
  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<SoundProvider>(context);
    return SizedBox(
          height: 230,
          child: soundProvider.records.isEmpty
              ? Center(child: Text('No records yet'))
              :ListView.builder(
            itemCount: soundProvider.records.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final record = soundProvider.records[index];
                  return Tile(i: index, record: record);
                },
              ),
        );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}