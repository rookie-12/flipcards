import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardCarousel extends StatefulWidget {
  @override
  _CardCarouselState createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // status bar
        Container(
          width: double.infinity,
          height: 20.0,
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: CardFlipper(),
          ),
        ),
        Container(
          width: double.infinity,
          height: 50.0,
          color: Colors.grey,
        )
      ],
    );
  }
}

class Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
          child: Image.asset(
            "assets/carousel_images/beach.jpg",
            fit: BoxFit.cover,
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                right: 20.0,
                left: 20.0,
              ),
              child: Text(
                "10Th Street",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  letterSpacing: 2.0,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "2 - 3",
                  style: TextStyle(
                    letterSpacing: -5.0,
                    color: Colors.white,
                    fontSize: 140.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    left: 10.0,
                  ),
                  child: Text(
                    "FT",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.wb_sunny,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: Text(
                    "65.1",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 50.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                  color: Colors.black.withOpacity(0.3),
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Mostly Cloud",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12.0,
                          right: 12.0,
                        ),
                        child: Icon(
                          Icons.wb_cloudy,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "11.2MPHENE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class CardFlipper extends StatefulWidget {
  @override
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: _buildCards(),
      ),
    );
  }

  List<Widget> _buildCards() {
    return [
      _buildCard(cardCount: 3, cardIndex: 0, scrollPercent: 0.0),
      _buildCard(cardCount: 3, cardIndex: 1, scrollPercent: 0.0),
      _buildCard(cardCount: 3, cardIndex: 2, scrollPercent: 0.0),
    ];
  }

  Widget _buildCard({int cardIndex, int cardCount, double scrollPercent}) {
    final cardScrollPercent = scrollPercent / (1 / cardCount);
    return FractionalTranslation(
      translation: Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(),
      ),
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {}

  void _onHorizontalDragEnd(DragEndDetails details) {}

  void _onHorizontalDragStart(DragStartDetails details) {}
}
