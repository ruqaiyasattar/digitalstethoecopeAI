import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:mboathoscope/buttons/WaveformButton.dart';

class RecordingList extends StatefulWidget {
  final List<String> records;
  //final List<ListItem> items;

  const RecordingList({super.key, required this.records});

  @override
  State<RecordingList> createState() => _RecordingListState();
}

class _RecordingListState extends State<RecordingList> {
  // late int _totalDuration;
  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return widget.records.isEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height / 10, horizontal: size.width / 5),
            child: Center(
              child: Container(
                  child: Text(
                'No records yet',
                style: TextStyle(color: Colors.black54, fontSize: 17),
              )),
            ),
          )
        : ListView.builder(
            itemCount: widget.records.length,
            shrinkWrap: true,
            reverse: true,
            itemBuilder: (context, index) {
              //final item = items[index];
              return ListTile(
                subtitle: Text('Recoding ${widget.records.length - index}'),

                title: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 70,
                      child: Container(
                        margin: const EdgeInsets.all(5.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          color: const Color(0xffF3F7FF),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 16,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  maxRadius: 15.0,
                                  backgroundColor: Colors.black,
                                  child: IconButton(
                                      color: Colors.white,
                                      iconSize: 15,
                                      icon: _selectedIndex == index
                                          ? (_isPlaying
                                              ? const Icon(
                                                  Icons.pause,
                                                  color: Color(0xff3D79FD),
                                                )
                                              : const Icon(
                                                  Icons.play_arrow,
                                                  color: Color(0xff3D79FD),
                                                ))
                                          : Icon(
                                              Icons.play_arrow,
                                              color: Color(0xff3D79FD),
                                            ),
                                      onPressed: () => {
                                            if (_isPlaying)
                                              {
                                                audioPlayer.pause(),
                                                setState(
                                                    () => {_isPlaying = false}),
                                              }
                                            else
                                              {
                                                _onPlay(
                                                    filePath: widget.records
                                                        .elementAt(index),
                                                    index: index)
                                              }
                                          }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: GestureDetector(
                        onTap: () {
                          null;
                          //to do task
                        },
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: IconButton(
                        icon: Icon(Icons.delete_sweep_outlined),
                        onPressed: () => {
                          // setState(
                          //   () => {
                          //     widget.records
                          //         .remove(widget.records.elementAt(index))
                          //   },
                          // )
                        },
                        color: Colors.black,
                      ),
                    ),
                    const Expanded(
                      flex: 10,
                      child: Icon(
                        Icons.share,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Stack(children: <Widget>[
                        Positioned(
                          child: Image.asset(
                            'assets/images/img_notiblack.png',
                          ),
                        ),
                        const Positioned(
                          top: 0.03,
                          left: 10,
                          child: CircleAvatar(
                            radius: 5,
                            backgroundColor: Color(0xff3D79FD),
                            foregroundColor: Colors.white,
                          ), //CircularAvatar
                        ),
                      ]),
                    ),
                  ],
                ),
                // subtitle: const Text("Recording 1"),
              );
            },
          );
  }

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> _onPlay(
      {required String filePath, isLocal: true, required int index}) async {
    await audioPlayer.setSourceUrl(filePath);
    if (!_isPlaying) {
      audioPlayer.resume();
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          // _completedPercentage =
          //     _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

  String _getDateFromFilePatah({required String filePath, isLocal: true}) {
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;

    return ('$year-$month-$day');
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
