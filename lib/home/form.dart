import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fssm/constants/color_const.dart';
import 'package:fssm/global/user_data.dart';
import 'package:fssm/widget/loader.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

import '../repositories/main_repo.dart';

class FSSMForm extends StatefulWidget {
  FSSMForm({Key? key}) : super(key: key);

  @override
  State<FSSMForm> createState() => _FSSMFormState();
}

class _FSSMFormState extends State<FSSMForm> {
  //Average Capa
  String selectedType = "";

  bool typeSelected = false;

  //Desludging
  String selectedTypes = "";

  bool typeSelecteds = false;

  // Initial Selected Value
  String dropdownvalue = 'Select Source Septage';

  final _formKey = GlobalKey<FormState>();

  //Septage Source
  var source = [
    "Select Source Septage",
    "Residential- Slum",
    "Residential- House",
    "Residential- Apartment",
    "Public Toilets"
        "Community toilets",
    "Commercial- Hotels",
    "Commercial- Bus stand/ Railway station",
    "Industrial- Domestic sewage",
    "Institutional- Govt Office",
    "Institutional- School/ College/ Hostel"
  ];

  var dt = DateTime.now();
  final TextEditingController _vehicleNumberCon = TextEditingController();
  final TextEditingController _quantitySludgeCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: primaryColor,
        title: Text(
          "FSSM Form",
          style: TextStyle(
            color: white,
            fontFamily: 'PopM',
            fontSize: 15,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              StreamBuilder(
                stream: Stream.periodic(
                  const Duration(seconds: 1),
                ),
                builder: (context, snapshot) {
                  String tdata = DateFormat("hh:mm:ss a").format(
                    DateTime.now(),
                  );
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(1, 0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "Date: ",
                                style: const TextStyle(
                                  fontFamily: 'PopB',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                Jiffy(dt).yMMMMd,
                                style: const TextStyle(
                                  fontFamily: 'PopM',
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(1, 0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Text(
                                "Operator Name: ",
                                style: const TextStyle(
                                  fontFamily: 'PopB',
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                userName,
                                style: const TextStyle(
                                  fontFamily: 'PopM',
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'PopM',
                            fontSize: 15,
                          ),
                          controller: _vehicleNumberCon,
                          maxLength: 13,
                          decoration: InputDecoration(
                            hintText: 'TS56YU7878',
                            counterText: "",
                            label: const Text("Vehicle Number"),
                            labelStyle: TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 13,
                              color: primaryColor,
                            ),
                            suffixIcon: Icon(
                              Icons.local_shipping,
                              color: primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Colors.teal),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Vehicle Number is required';
                            }
                            if (val.length < 8) {
                              return 'Please Enter valid vehicle number';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'PopM',
                            fontSize: 15,
                          ),
                          keyboardType: TextInputType.number,
                          controller: _quantitySludgeCon,
                          decoration: InputDecoration(
                            hintText: '480 Tons',
                            label: const Text("Quantity of sludge recieved"),
                            labelStyle: TextStyle(
                              fontFamily: 'MonS',
                              fontSize: 13,
                              color: primaryColor,
                            ),
                            suffixIcon: Icon(
                              Icons.scale,
                              color: primaryColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Colors.teal),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Sludge recieved is required';
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Source of Septage: ",
                              style: const TextStyle(
                                fontFamily: 'PopB',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.grey)
                                  // color: white,
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey.withOpacity(0.2),
                                  //     spreadRadius: 1,
                                  //     blurRadius: 1,
                                  //     offset: const Offset(0, 1),
                                  //   ),
                                  //   BoxShadow(
                                  //     color: Colors.grey.withOpacity(0.2),
                                  //     spreadRadius: 1,
                                  //     blurRadius: 1,
                                  //     offset: const Offset(1, 0),
                                  //   ),
                                  // ],
                                  ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                    isExpanded: true,
                                    // Initial Value
                                    value: dropdownvalue,

                                    // Down Arrow Icon
                                    icon: Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                      color: primaryColor,
                                    ),

                                    // Array list of items
                                    items: source.map((String items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(
                                          items,
                                          style: TextStyle(
                                            color: primaryColor,
                                            fontFamily: 'PopM',
                                            fontSize: 15,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    // After selecting the desired option,it will
                                    // change button value to selected value
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownvalue = newValue!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Average Capacity: ",
                              style: const TextStyle(
                                fontFamily: 'PopB',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 3.0),
                            child: Center(
                              child: GroupButton(
                                options: GroupButtonOptions(
                                  spacing: 7.0,
                                  runSpacing: 0.3,
                                  selectedColor: primaryColor,
                                  selectedTextStyle: TextStyle(
                                      color: white,
                                      fontFamily: 'PopM',
                                      fontWeight: FontWeight.w600),
                                  unselectedTextStyle: TextStyle(
                                      color: black,
                                      fontFamily: 'PopR',
                                      fontWeight: FontWeight.w200),
                                  borderRadius: BorderRadius.circular(8),
                                  unselectedColor:
                                      Colors.blueGrey.shade200.withOpacity(0.4),
                                ),
                                isRadio: true,
                                onSelected: (index, isSelected, _) {
                                  setState(() {
                                    typeSelected = true;
                                    selectedType = '$isSelected';
                                  });
                                  print(index.toString() + 'is selected');
                                },
                                buttons: [
                                  "5 Tons",
                                  "10 Tons",
                                  "15 Tons",
                                  "20 Tons",
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Delsudging operator wore PPE: ",
                              style: const TextStyle(
                                fontFamily: 'PopB',
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: GroupButton(
                              options: GroupButtonOptions(
                                mainGroupAlignment: MainGroupAlignment.start,
                                spacing: 7.0,
                                runSpacing: 0.3,
                                selectedColor: primaryColor,
                                selectedTextStyle: TextStyle(
                                    color: white,
                                    fontFamily: 'PopM',
                                    fontWeight: FontWeight.w600),
                                unselectedTextStyle: TextStyle(
                                    color: black,
                                    fontFamily: 'PopR',
                                    fontWeight: FontWeight.w200),
                                borderRadius: BorderRadius.circular(8),
                                unselectedColor:
                                    Colors.blueGrey.shade200.withOpacity(0.4),
                              ),
                              isRadio: true,
                              onSelected: (index, isSelected, _) {
                                setState(() {
                                  typeSelecteds = true;
                                  selectedTypes = '$isSelected';
                                });
                                print(index.toString() + 'is selected');
                              },
                              buttons: [
                                "Yes",
                                "No",
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor),
                            ),
                            onPressed: () async {
                              String sludRe = _quantitySludgeCon.text;
                              String vehNu = _vehicleNumberCon.text;

                              String sourceSp = dropdownvalue ==
                                      "Residential- Slum"
                                  ? "ResidentialSlum"
                                  : dropdownvalue == "Residential- House"
                                      ? "ResidentialHouse"
                                      : dropdownvalue ==
                                              "Residential- Apartment"
                                          ? "ResidentialApartment"
                                          : dropdownvalue == "Community toilets"
                                              ? "CommunityToilets"
                                              : dropdownvalue ==
                                                      "Public Toilets"
                                                  ? "PublicToilets"
                                                  : dropdownvalue ==
                                                          "Commercial- Hotels"
                                                      ? "CommercialHotels"
                                                      : dropdownvalue ==
                                                              "Commercial- Bus stand/ Railway station"
                                                          ? "CommercialBusstandRailwaystation"
                                                          : dropdownvalue ==
                                                                  "Industrial- Domestic sewage"
                                                              ? "IndustrialDomesticsewage"
                                                              : dropdownvalue ==
                                                                      "Institutional- Govt Office"
                                                                  ? "InstitutionalGovtOffice"
                                                                  : dropdownvalue ==
                                                                          "Institutional- School/ College/ Hostel"
                                                                      ? "InstitutionalSchoolCollegeHostel"
                                                                      : "";

                              String avgC = selectedType == "0"
                                  ? "5"
                                  : selectedType == "1"
                                      ? "10"
                                      : selectedType == "2"
                                          ? "15"
                                          : selectedType == "3"
                                              ? "20"
                                              : "";

                              String deslu =
                                  selectedTypes == "0" ? "true" : "false";

                              if (_formKey.currentState!.validate()) {
                                if (dropdownvalue == "Select Source Septage") {
                                  Fluttertoast.showToast(
                                      msg: "Please Select source of septage");
                                } else if (selectedType == "") {
                                  Fluttertoast.showToast(
                                      msg: "Please Select average capacity");
                                } else if (selectedTypes == "") {
                                  Fluttertoast.showToast(
                                      msg:
                                          "Please Select desludgeing operator wore PPE");
                                } else {
                                  showLoaderDialog(context,
                                      "Submitting...Please wait..!", 40);
                                  await userAddOps(sludRe, avgC, sourceSp,
                                      vehNu, deslu, context);
                                }

                                // showLoaderDialog(
                                //     context, "Logging you in...", 50);

                                // userlogin(useremail, password, context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Material(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        height: 60,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                            child: Text(
                                          "Please Fill all the required details...",
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.transparent,
                                    elevation: 0,
                                  ),
                                );
                              }

                              // print("--------------> " +
                              //     fcmtoken.toString() +
                              //     " <-----------------");
                              // print("---------------->> " +
                              //     _deviceId.toString() +
                              //     " <<-------------");
                              // print("---------------->>>> " +
                              //     _deviceType.toString() +
                              //     " <<<<-------------");

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => UserSectionPage()));
                            },
                            child: SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width / 1.4,
                              child: Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: white,
                                    fontSize: 15,
                                    fontFamily: 'MonS',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*



 */
