import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const CardScreen(),
    );
  }
}

class CardScreen extends StatefulWidget {
  const CardScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen>
    with SingleTickerProviderStateMixin {
  Offset mousePos = const Offset(0, 0);

  late final AnimationController _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  late Animation<Offset> _animation =
      Tween<Offset>(begin: mousePos, end: const Offset(0, 0))
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    double cardWidth = 540;
    double cardHeight = 300;

    return Scaffold(
        backgroundColor: const Color(0xFFFEF3F6),
        body: Stack(
          children: [
            //Shadow
            Positioned(
                top: h * .1,
                right: w * .9,
                child: Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 800,
                      spreadRadius: 350,
                      color: Color(0xFFFED2A6),
                    )
                  ]),
                )),

            //Shadow
            Positioned(
                top: h * .1,
                right: w * .1,
                child: Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 1600,
                      spreadRadius: 400,
                      color: Color(0xFFEF7FE6),
                    )
                  ]),
                )),

            //Sphere
            Positioned(
                top: (h * .5) - 190,
                left: (w * .5) + 120,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(
                        (mousePos.dx / 15) / 6, (mousePos.dy / 15) / 6, 0.0),
                  child: _buildSphere(
                    100,
                  ),
                )),

            //Sphere
            Positioned(
              top: (h * .5) - 180,
              left: (w * .5) - (cardWidth / 2) - 85,
              child: _buildSphere(
                150,
              ),
            ),

            //The Card
            Positioned.fill(
              child: Center(
                child: MouseRegion(
                  onEnter: (event) {
                    // mousePos = event.position;
                    if (_controller.isAnimating) {
                      _controller.stop();
                      Offset temp = event.delta;
                      mousePos =
                          Offset(mousePos.dx + temp.dx, mousePos.dy + temp.dy);
                    }
                  },
                  onHover: (mData) {
                    setState(() {
                      Offset temp = mData.delta;
                      mousePos =
                          Offset(mousePos.dx + temp.dx, mousePos.dy + temp.dy);
                    });
                  },
                  onExit: (mData) {
                    // print(mousePos);

                    _animation =
                        Tween<Offset>(begin: mousePos, end: const Offset(0, 0))
                            .animate(CurvedAnimation(
                                parent: _controller, curve: Curves.easeIn));

                    _controller.forward(from: 0);
                  },
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, ch) {
                      // mousePos = _animation.value;
                      print('_animation.value');
                      print(_animation.value);
                      print(mousePos);
                      _setMousePos();

                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, .001)
                          ..rotateX((mousePos.dy) / 500)
                          ..rotateY((-mousePos.dx) / 5000),
                        alignment: Alignment.center,
                        child: ch,
                      );
                    },
                    child: _buildCard(cardHeight, cardWidth),
                  ),
                ),
              ),
            ),

            //Sphere
            Positioned(
                top: (h * .5) - 100,
                left: (w * .5) + (cardWidth / 2) - 63,
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, ch) {
                    return Transform(
                      transform: Matrix4.identity()
                        ..translate(
                          mousePos.dx / 15,
                          mousePos.dy / 15,
                          0.0,
                        ),
                      child: ch,
                    );
                  },
                  child: _buildSphere(
                    200,
                  ),
                )),

            //Sphere
            Positioned(
                top: (h * .5) - 100,
                left: (w * .5) + (cardWidth / 2) - 63,
                child: Transform(
                  transform: Matrix4.identity()
                    ..translate(
                      -(mousePos.dx / 15) * 2,
                      -(mousePos.dy / 15) * 2,
                      0.0,
                    ),
                  child: _buildSphere(50, withBoxShodow: true),
                )),
          ],
        ));
  }

  void _setMousePos() {
    if (_controller.isAnimating) {
      mousePos = _animation.value;
    }
  }

  ClipRRect _buildCard(double cardHeight, double cardWidth) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: cardHeight,
          width: cardWidth,
          // transform: Matrix4.identity(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(.2),
              border: Border.all(width: .5, color: Colors.white)),
          child: Column(children: [
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox.expand(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'GLASS BANK',
                            style: TextStyle(
                                color: Color.fromARGB(255, 216, 123, 211),
                                fontWeight: FontWeight.bold),
                          ),
                          Text('5423  1243  2457  7354',
                              style: TextStyle(
                                  letterSpacing: 2,
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold))
                        ]),
                  ),
                )),
            Expanded(
              flex: 3,
              child: DefaultTextStyle(
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 11),
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Color(0xFF4D2DF6),
                        Color(0xFF4D2DF6),
                        Color(0xFF4D2DF6),
                        Color.fromARGB(255, 190, 42, 183),
                        Color.fromARGB(255, 241, 8, 230),
                      ])),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(children: [
                            const Text(
                              'VALID THRU',
                            ),
                            _verticalSpace(5),
                            const Text('12/25')
                          ]),
                          const Text(
                            'TARIQ ZIYAD',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 17),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 23,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _buildSphere(50, opacity: .6),
                      ),
                    ),
                    Positioned(
                      right: 63,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: _buildSphere(30, opacity: .4),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  Container _buildSphere(
    double height2, {
    double opacity = 1,
    bool withBoxShodow = false,
  }) {
    return Container(
      height: height2,
      width: height2,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
                // Color(0xFFF644F8).withOpacity(opacity),
                // Color(0xFFFF74FF).withOpacity(opacity),
                // Color(0xFFFF74FF).withOpacity(opacity),
                const Color.fromARGB(255, 255, 141, 255).withOpacity(opacity),
                const Color.fromARGB(255, 255, 141, 255).withOpacity(opacity),
                const Color(0xFFFDB6FF).withOpacity(opacity),
                const Color.fromARGB(255, 254, 211, 255).withOpacity(opacity),
                const Color.fromARGB(255, 250, 236, 250).withOpacity(opacity),
                const Color(0xFFFFFFFF).withOpacity(opacity),
                const Color(0xFFFFFFFF).withOpacity(opacity),

                // Color(0xFFFFFFFF).withOpacity(opacity),
              ]),
          borderRadius: BorderRadius.circular(height2),
          boxShadow: withBoxShodow
              ? [
                  BoxShadow(
                    blurRadius: 12,
                    spreadRadius: 3,
                    offset: const Offset(12, 20),
                    color: Colors.grey.withOpacity(.2),
                  )
                ]
              : null),
    );
  }

  _verticalSpace(double height) => SizedBox(
        height: height,
      );
}
