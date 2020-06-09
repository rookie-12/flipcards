import 'dart:ui';

import 'package:flipcards/CardData.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardCarousel extends StatefulWidget {
  @override
  _CardCarouselState createState() => _CardCarouselState();
}

class _CardCarouselState extends State<CardCarousel> {
  double scrollPercent = 0.0;

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
            padding: const EdgeInsets.all(16.0),
            child: CardFlipper(
                cards: demoCards,
                onScroll: (double scrollPercent) {
                  setState(() {
                    this.scrollPercent = scrollPercent;
                  });
                }),
          ),
        ),
        BottomBar(scrollPercent: scrollPercent, cardCount: demoCards.length)
      ],
    );
  }
}

class Card extends StatelessWidget {
  final CardViewModel cardViewModel;
  final double parallaxPercent;

  const Card({Key key, this.cardViewModel, this.parallaxPercent = 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
          child: FractionalTranslation(
            translation: Offset(parallaxPercent * 2.0, 0.0),
            child: OverflowBox(
              maxWidth: double.infinity,
              child: Image.asset(
                cardViewModel.backdropAssetPath,
                fit: BoxFit.cover,
              ),
            ),
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
                cardViewModel.address,
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
                  '${cardViewModel.minHeightInFeet} - ${cardViewModel.maxHeightInFeet}',
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
                    cardViewModel.tempInDegrees.toString(),
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
                        cardViewModel.weatherType,
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
                        "${cardViewModel.windSpeedInMph}MPH${cardViewModel.cardinalDirection}",
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
  final List<CardViewModel> cards;
  final Function(double scrollPercent) onScroll;

  const CardFlipper({Key key, this.cards, this.onScroll}) : super(key: key);

  @override
  _CardFlipperState createState() => _CardFlipperState();
}

class _CardFlipperState extends State<CardFlipper>
    with TickerProviderStateMixin {
  double scrollPercent = 0.0;
  Offset startDrag;
  double startDragPercentScroll;
  double finishScrollStart;
  double finishScrollEnd;
  AnimationController finishScrollController;
  int numCards;

  @override
  void initState() {
    super.initState();
    numCards = widget.cards.length;
    finishScrollController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    )..addListener(() {
        setState(() {
          scrollPercent = lerpDouble(
              finishScrollStart, finishScrollEnd, finishScrollController.value);
          if (widget.onScroll != null) {
            widget.onScroll(scrollPercent);
          }
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onHorizontalDragStart,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      //get detection behind the widget too
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: _buildCards(),
      ),
    );
  }

  List<Widget> _buildCards() {
    int index = -1;
    return widget.cards.map((CardViewModel cardViewModel) {
      ++index;
      return _buildCard(
        cardCount: numCards,
        cardIndex: index,
        scrollPercent: scrollPercent,
        viewModel: cardViewModel,
      );
    }).toList();
  }

  Widget _buildCard(
      {int cardIndex,
      int cardCount,
      double scrollPercent,
      CardViewModel viewModel}) {
    final cardScrollPercent = scrollPercent / (1 / cardCount);
    final parallax = scrollPercent - (cardIndex / cardCount);
    return FractionalTranslation(
      translation: Offset(cardIndex - cardScrollPercent, 0.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(cardViewModel: viewModel, parallaxPercent: parallax),
      ),
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    final currDrag = details.globalPosition;
    //to calculate drag distance
    final dragDistance = currDrag.dx - startDrag.dx;
    //1 for 1 displacement
    final singleCardDragPercent = dragDistance / context.size.width;
    setState(() {
      //before user started scrolling position

      ///question
      ///1. why it is negative?
      ///2. what is clamp?
      ///3. why 1/numcards?

      ///Answers
      ///3. To avoid displacement of last card; //need details
      ///2.

      scrollPercent =
          (startDragPercentScroll + (-singleCardDragPercent / numCards))
              .clamp(0.0, 1.0 - (1 / numCards));

      if (widget.onScroll != null) {
        widget.onScroll(scrollPercent);
      }
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    finishScrollStart = scrollPercent;
    finishScrollEnd = (scrollPercent * numCards).round() / numCards;
    finishScrollController.forward(from: 0.0);
    setState(() {
      startDrag = null;
      startDragPercentScroll = null;
    });
  }

  void _onHorizontalDragStart(DragStartDetails details) {
    startDrag = details.globalPosition;
    //To record percent scroll when the user starts scrolling;
    startDragPercentScroll = scrollPercent;
  }
}

class BottomBar extends StatelessWidget {
  final double scrollPercent;
  final int cardCount;

  const BottomBar({Key key, this.scrollPercent, this.cardCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 5.0,
              child: ScrollIndicator(
                cardCount: cardCount,
                scrollPercent: scrollPercent,
              ),
            ),
          ),
          Expanded(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

class ScrollIndicator extends StatelessWidget {
  final int cardCount;
  final double scrollPercent;

  const ScrollIndicator({Key key, this.cardCount, this.scrollPercent: 0.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ScrollIndicatorPainter(
          cardCount: cardCount, scrollPercent: scrollPercent),
      child: Container(),
    );
  }
}

class ScrollIndicatorPainter extends CustomPainter {
  final int cardCount;
  final double scrollPercent;
  final Paint trackPaint;
  final Paint thumbPaint;

  ScrollIndicatorPainter({
    this.cardCount,
    this.scrollPercent,
  })  : trackPaint = Paint()
          ..color = const Color(0xFF444444)
          ..style = PaintingStyle.fill,
        thumbPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    //Draw track
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        topLeft: Radius.circular(3.0),
        bottomRight: Radius.circular(3.0),
        bottomLeft: Radius.circular(3.0),
        topRight: Radius.circular(3.0),
      ),
      trackPaint,
    );

    //Draw thumb
    final thumbWidth = size.width / cardCount;
    final thumbLeft = scrollPercent * size.width;

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(thumbLeft, 0.0, thumbWidth, size.height),
        topLeft: Radius.circular(3.0),
        bottomRight: Radius.circular(3.0),
        bottomLeft: Radius.circular(3.0),
        topRight: Radius.circular(3.0),
      ),
      thumbPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
