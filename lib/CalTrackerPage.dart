import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pawlorie/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CalTrackerPage extends StatefulWidget {
  @override
  _CalTrackerState createState() => _CalTrackerState();
}

class _CalTrackerState extends State<CalTrackerPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _caloriesController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColor.darkBlue),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        // title: const Text('Pet Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.yellowGold,
              ),
              width: double.infinity,
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/pet_image.jpg'), // Replace with your pet image asset
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Pet Name',
                      style: GoogleFonts.rubik(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30.0),
            child: Container(
              decoration: BoxDecoration(
                  color: AppColor.darkBlue, 
                  borderRadius: BorderRadius.circular(10)
              ),
             // Set the background color of the TabBar
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Tracker',),
                  Tab(text: 'Summary'),
                  Tab(text: 'Info'),
                ],
                labelColor: Colors.white,
                labelStyle: TextStyle(
                  fontSize: 18,
                ), // Color of the selected tab text
                unselectedLabelColor: Colors.white, // Color of the unselected tab text
                indicator: CustomTabIndicator(
                  indicatorWidth: 125, // Set the desired indicator width
                  color: AppColor.lightBlue,
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildHomeTab(),
                _buildSummaryTab(),
                _buildPetInfoTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Today",
            style: GoogleFonts.rubik(
                              fontSize: 31,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Container(
                height: 120,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10))
                ,
                
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Intake",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                              fontSize: 15,
                              color: AppColor.blue)),
                            Text(
                              "Remaining",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColor.darkBlue)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "0",
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 30,
                              color: AppColor.blue),
                          
                            ),
                            Text(
                              "123",
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 30,
                              color: AppColor.darkBlue)
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Goal",
                              textAlign: TextAlign.left,
                            ),
                            Text(
                              "123",
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColor.blue,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text("Add Food Intake",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              
                            ),),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        decoration:InputDecoration(
                          hintText: 'Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white
                        ),
                        style: TextStyle(color: AppColor.darkBlue),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _caloriesController,
                              decoration: InputDecoration(
                                hintText: 'Amount of Calories',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter amount of calories';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 16), 
                          Expanded(
                            child: TextFormField(
                              controller: _timeController,
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Time',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                filled: true,
                                fillColor: Colors.white
                              ),
                              onTap: () => _selectTime(context),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a time';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: (){},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.yellowGold,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('Add',
                                    style: TextStyle(
                                      color:AppColor.darkBlue,
                                      fontSize: 15
                                    )
                                ),
                          ),
                                    ),
                      ),





                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTab() {
    return const Center(
      child: Text('Summary Tab Content'),
    );
  }

  Widget _buildPetInfoTab() {
    return const Center(
      child: Text('Pet Info Tab Content'),
    );
  }
}

class CustomTabIndicator extends Decoration {
  final double indicatorWidth;
  final Color color;

  CustomTabIndicator({required this.indicatorWidth, required this.color});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter(this, indicatorWidth, color);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;
  final double indicatorWidth;
  final Color color;

  _CustomPainter(this.decoration, this.indicatorWidth, this.color);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    final double width = indicatorWidth;
    final double height = 48.0; // Height of the indicator
    final double xOffset = (configuration.size!.width / 2) - (width / 2);
    final double yOffset = configuration.size!.height - height;

    final Rect rect = Offset(offset.dx + xOffset, offset.dy + yOffset) & Size(width, height);
    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(3.0));
    canvas.drawRRect(rrect, paint);
  }
}
