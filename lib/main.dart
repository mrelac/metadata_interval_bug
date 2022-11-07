// import 'package:audio_session/audio_session.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:metadata_interval_bug/control_buttons.dart';
import 'package:metadata_interval_bug/icy_utils.dart';
import 'package:metadata_interval_bug/station_card.dart';

void main() {
  runApp(const MyApp());
}

const title = 'IcyMetadata bug';
const greyShade100 = Color.fromARGB(255, 245, 245, 245);
const greyShade200 = Color.fromARGB(255, 238, 238, 238);
const greyShade300 = Color.fromARGB(255, 224, 224, 224);
const greyShade400 = Color.fromARGB(255, 189, 189, 189);
const greyShade500 = Color.fromARGB(255, 158, 158, 158);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _player = AudioPlayer();
  final _currentIcy = <Widget>[];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      if (kDebugMode) print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      await _player.setAudioSource(
          AudioSource.uri(Uri.parse(_stations[_currentIndex].stationUrl)));
      final icy = IcyUtils.buildIcyOutput(_player.icyMetadata);
      setState(() => _currentIcy
        ..clear
        ..addAll(icy));
      IcyUtils.printIcy(_player.icyMetadata);
    } catch (e) {
      if (kDebugMode) print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              height: 200,
              child: ListView.builder(
                  itemCount: _stations.length,
                  itemBuilder: (context, index) {
                    return _buildStationTile(index, _stations[index]);
                  }),
            ),
            const SizedBox(height: 20),
            ControlButtons(_player),
            const Text('Icy Metadata Output:'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _currentIcy),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationTile(int index, StationCard card) {
    return ListTile(
        tileColor: index == _currentIndex ? greyShade500 : greyShade300,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('$index'),
                const SizedBox(width: 15.0),
                Text(_stations[index].station),
                const SizedBox(width: 15.0),
                Flexible(
                  child: Text(
                    style: const TextStyle(fontSize: 10),
                    'Song: ${card.song ?? "<null>"}',
                  ),
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Flexible(
                child: SelectableText(
                    style: const TextStyle(fontSize: 8), card.stationUrl),
              ),
            ]),
          ],
        ),
        onTap: () async {
          try {
            final newCurrent = _stations[index];
            await _player.setAudioSource(
                AudioSource.uri(Uri.parse(newCurrent.stationUrl)));
            final IcyMetadata? icy = _player.icyMetadata;
            final newCard =
                _stations[index].copyWith(song: icy?.info?.title ?? "<null>");

            if (kDebugMode) print('Loading ${newCurrent.station}');
            IcyUtils.printIcy(icy);
            final newIcy = IcyUtils.buildIcyOutput(icy);

            _player.play();

            setState(() {
              _currentIndex = index;
              _currentIcy
                ..clear()
                ..addAll(newIcy);
              _stations[index] = newCard;
            });
          } catch (e) {
            if (kDebugMode) print("Loading station failed: $e");
            _player.stop();
          }
        });
  }

  final List<StationCard> _stations = [
    const StationCard(
        id: '0',
        station: 'WETF',
        stationUrl:
            'https://ssl-proxy.icastcenter.com/get.php?type=Icecast&server=199.180.72.2&port=9007&mount=/stream&data=mp3'),
    const StationCard(
        id: '1',
        station: 'KCSM',
        stationUrl: 'https://ice5.securenetsystems.net/KCSM'),
    const StationCard(
        id: '2',
        station: 'WDCB',
        stationUrl: 'https://wdcb-ice.streamguys1.com/wdcb128'),
  ];
}
