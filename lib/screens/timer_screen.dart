import 'package:flutter/material.dart';

import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({Key? key}) : super(key: key);
  static const route = '/timer';

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool _isPlaying = false;
  bool _snotified = false;
  bool _initState = false;

  String get countText {
    Duration count = _controller.duration! * _controller.value;
    return '${(count.inHours % 60).toString()}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void notify() {
    if (countText == '0:00:00') {
      if (!_snotified) {
        FlutterRingtonePlayer.play(fromAsset: "assets/sounds/radar.mp3");
        _snotified = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_initState) {
      super.didChangeDependencies();
      final duration = ModalRoute.of(context)!.settings.arguments as int;
      _controller = AnimationController(
          vsync: this, duration: Duration(seconds: duration));
      _controller.addListener(() {
        notify();
        if (_controller.isAnimating) {
          setState(() {
            progress = _controller.value;
          });
        } else {
          setState(() {
            progress = 1.0;
          });
        }
      });
      _initState = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: CircularProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.black54,
                    ),
                  ),
                  Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (ctx, child) => Text(
                        countText,
                        style: const TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              iconSize: 40,
              onPressed: () {
                if (_controller.isAnimating) {
                  _controller.stop();
                  setState(() {
                    _isPlaying = false;
                  });
                } else {
                  _controller.reverse(
                      from: _controller.value == 0 ? 1.0 : _controller.value);
                  setState(() {
                    _isPlaying = true;
                  });
                }
              },
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              alignment: Alignment.center,
              width: double.infinity,
              child: OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 106, 95)),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                onPressed: () {
                  _snotified = true;
                  _controller.reset();
                  setState(() {
                    _isPlaying = false;
                  });
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Stop Timer',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
