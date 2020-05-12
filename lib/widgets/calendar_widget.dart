import 'package:whizz/models/task_model.dart';
import 'package:whizz/widgets/task_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:whizz/helpers/extensions.dart';

class CalendarWidget extends StatefulWidget {
  final List<TaskModel> tasks;

  const CalendarWidget({Key key, this.tasks}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _currentDate = DateTime.now();
  ScrollController _scrollControllerList = ScrollController();
  ScrollController _scrollControllerFull = ScrollController();
  bool listScrollHandled = true;

  @override
  void initState() {
    _scrollControllerList.addListener(() {
      if (_scrollControllerList.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_scrollControllerList.offset < -30) {
          _scrollControllerList.position.moveTo(0,
              duration: Duration(milliseconds: 10), curve: Curves.easeIn);

          if (_scrollControllerFull.offset == 380) {
            if (!listScrollHandled) {
              listScrollHandled = true;
            } else {
              _scrollControllerFull.position.moveTo(0,
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            }
          }
        }
      } else {
        if (_scrollControllerList.offset > 30) {
          if (_scrollControllerFull.offset == 0) {
            _scrollControllerList.position.moveTo(0,
                duration: Duration(milliseconds: 10), curve: Curves.easeIn);
            _scrollControllerFull.position.moveTo(380,
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          } else {
            listScrollHandled = false;
          }
        }
      }
    });

    // _scrollControllerList.addListener(() {
    //   if (_scrollControllerList.position.userScrollDirection ==
    //       ScrollDirection.forward) {
    //     _scrollControllerFull.position
    //         .moveTo(0, duration: Duration(milliseconds: 100));
    //   } else {
    //     if (_scrollControllerFull.position.pixels <= 0) {
    //       _scrollControllerList.position
    //           .moveTo(0, duration: Duration(milliseconds: 100));
    //     }
    //   }
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<TaskModel> displayedItems = widget.tasks
        .where((task) => task.date.isSameDateAs(_currentDate))
        .toList();

    // EventList<Event> markedDateMap = new EventList<Event>(
    //     events: displayedItems.map((item1) {
    //   return {
    //     item1.date: displayedItems
    //         .where((item2) => item2.date.isSameDateAs(item1.date))
    //         .map((item3) {
    //       return Event(date: item3.date);
    //     }).toList()
    //   };
    // }));

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomScrollView(
        controller: _scrollControllerFull,
        physics: NeverScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            key: Key('CalendarSliver'),
            child: Column(
              children: <Widget>[
                CalendarCarousel<Event>(
                  headerTitleTouchable: false,
                  dayCrossAxisAlignment: CrossAxisAlignment.center,
                  dayMainAxisAlignment: MainAxisAlignment.center,
                  firstDayOfWeek: 1,
                  onDayPressed: (DateTime date, List<Event> events) {
                    setState(() {
                      _currentDate = date;
                    });
                  },
                  weekendTextStyle: TextStyle(
                    color: Colors.red,
                  ),
                  thisMonthDayBorderColor: Colors.transparent,
                  // customDayBuilder: (
                  //   bool isSelectable,
                  //   int index,
                  //   bool isSelectedDay,
                  //   bool isToday,
                  //   bool isPrevMonthDay,
                  //   TextStyle textStyle,
                  //   bool isNextMonthDay,
                  //   bool isThisMonthDay,
                  //   DateTime day,
                  // ) {
                  //   if (day.day == 15) {
                  //     return Center(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: <Widget>[
                  //           Text(day.day.toString()),
                  //           Icon(
                  //             Icons.local_airport,
                  //             size: 10,
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   } else {
                  //     return null;
                  //   }
                  // },
                  weekFormat: false,

                  //markedDatesMap: markedDateMap,
                  markedDateIconBuilder: (Event event) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        color: _currentDate.isSameDateAs(event.date)
                            ? Colors.purple
                            : Theme.of(context).primaryColor,
                        height: 6,
                        width: 6,
                      ),
                    );
                  },

                  height: 380,
                  selectedDateTime: _currentDate,
                  todayButtonColor:
                      Theme.of(context).primaryColor.withOpacity(0.75),
                  selectedDayButtonColor: Colors.grey,
                  daysHaveCircularBorder: true,
                  headerTextStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                  leftButtonIcon: Icon(Icons.arrow_back_ios, size: 20),
                  rightButtonIcon: Icon(Icons.arrow_forward_ios, size: 20),
                ),
                Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Theme.of(context).primaryColor.withOpacity(0.75)),
              ],
            ),
          ),
          SliverFillRemaining(
            key: Key('ListSliver'),
            child: Container(
              child: displayedItems.length > 0
                  ? ListView.builder(
                      controller: _scrollControllerList,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      itemCount: displayedItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskItemWidget(
                          task: displayedItems[index],
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          isFirst: false,
                        );
                      })
                  : Center(
                      child: Text('No tasks on this day'),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
