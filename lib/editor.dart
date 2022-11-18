import 'package:assignment/database/database.dart';
import 'package:assignment/database/trip.dart';
import 'package:assignment/home_page.dart';
import 'package:assignment/main.dart';
import 'package:flutter/material.dart';

class Editor extends StatefulWidget {
  AppDB db;
  int? tripId;

  Editor({super.key, required this.db, this.tripId});

  @override
  State<StatefulWidget> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  String title = "Create Trip";
  var formKey = GlobalKey<FormState>();

  var tripNameController = TextEditingController();
  var tripDestinationController = TextEditingController();
  var tripDateController = TextEditingController();
  bool tripAssessmentController = false;
  var tripDescriptionController = TextEditingController();
  var tripExpectedCostController = TextEditingController();
  var tripNumbersAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.tripId != null) {
      title = "Edit Trip";
      widget.db.tripDAO.findTripById(widget.tripId!).then((trip) => {
            setState((() => {
                  tripNameController.text = trip!.name,
                  tripDestinationController.text = trip.destination,
                  tripDateController.text = trip.date,
                  tripAssessmentController = trip.assessment,
                  tripDescriptionController.text = trip.description!,
                  tripExpectedCostController.text =
                      trip.expectedCost.toString(),
                  tripNumbersAmountController.text =
                      trip.membersAmount.toString(),
                }))
          });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.yellowAccent)),
        actions: takeActs(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            createInputPadding(tripNameController, "Name", "Name of the trip"),
            createInputPadding(tripDestinationController, "Destination",
                "Destination of the trip"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.datetime,
                controller: tripDateController,
                validator: (value) =>
                    value!.isEmpty ? "Missing information" : null,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  tripDateController.text =
                      await pickerOfDate(context, tripDateController);
                },
                decoration: InputDecoration(
                    labelText: "Date",
                    hintText: "Pick the date",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.5))),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(children: [
                  const Text("Risk Assessment"),
                  Switch(
                      value: tripAssessmentController,
                      onChanged: (value) => {
                            setState(() => {tripAssessmentController = value})
                          })
                ])),
            createInputPadding(tripDescriptionController, "Trip's description",
                "Description of the trip"),
            createInputPadding(
                tripExpectedCostController, "Expected cost", "Ex: 1000",
                type: TextInputType.number),
            createInputPadding(
                tripNumbersAmountController, "Number of participants", "Ex: 10",
                type: TextInputType.number),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                child: const Text("Save"),
                onPressed: () => {
                  if (formKey.currentState!.validate())
                    {
                      if (widget.tripId == null)
                        {createTrip()}
                      else
                        {updateTrip()}
                    }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            )
          ]),
        ),
      ),
    );
  }

  List<Widget> takeActs() {
    List<Widget> actWidgets = [];
    if (widget.tripId != null) {
      actWidgets.add(IconButton(
          onPressed: () => {
                widget.db.tripDAO.deleteTrip(widget.tripId!).then(((value) => {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Delete successfully!"),
                        duration: Duration(seconds: 4),
                      )),
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(db: widget.db)),
                          (route) => false)
                    }))
              },
          icon: const Icon(Icons.delete)));
    }
    return actWidgets;
  }

  Future<String> pickerOfDate(BuildContext buildContext,
      TextEditingController tripDateController) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010),
        lastDate: DateTime(2050));

    return "${pickedDate!.toLocal()}".split(" ")[0];
  }

  createTrip() {
    String name = tripNameController.text;
    String destination = tripDestinationController.text;
    String date = tripDateController.text;
    String description = tripDescriptionController.text;
    double expectedCost = double.parse(tripExpectedCostController.text);
    int numberAmount = int.parse(tripNumbersAmountController.text);

    if (expectedCost == 0) {}
    widget.db.tripDAO
        .insertTrip(Trip(
            name: name,
            destination: destination,
            date: date,
            assessment: tripAssessmentController,
            description: description,
            expectedCost: expectedCost,
            membersAmount: numberAmount))
        .then((value) => {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Add trip successfully!!!"),
                duration: Duration(seconds: 4),
              )),
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(db: widget.db)),
                  (route) => false)
            });
  }

  updateTrip() {
    String name = tripNameController.text;
    String destination = tripDestinationController.text;
    String date = tripDateController.text;
    String description = tripDescriptionController.text;
    double expectedCost = double.parse(tripExpectedCostController.text);
    int numberAmount = int.parse(tripNumbersAmountController.text);

    widget.db.tripDAO.findTripById(widget.tripId!).then((trip) => {
          trip!.name = name,
          trip.destination = destination,
          trip.date = date,
          trip.assessment = tripAssessmentController,
          trip.description = description,
          trip.expectedCost = expectedCost,
          trip.membersAmount = numberAmount,
          widget.db.tripDAO.updateTrip(trip).then((value) => {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Update trip successfully!!!"),
                  duration: Duration(seconds: 4),
                )),
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(db: widget.db)),
                    (route) => false)
              })
        });
  }

  Widget createInputPadding(
      TextEditingController controller, String labelText, String hintText,
      {TextInputType? type}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        keyboardType: type ?? TextInputType.text,
        controller: controller,
        validator: (value) => value!.isEmpty ? "Missing information" : null,
        decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(2.5))),
      ),
    );
  }
}
