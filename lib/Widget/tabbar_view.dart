import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_app/Cameras/camera.dart';
import 'package:inventory_app/Cameras/camera1.dart';
import 'package:inventory_app/Cameras/camera2.dart';
import 'package:inventory_app/Cameras/camera3.dart';
import 'package:inventory_app/Cameras/camera4.dart';

class MyTabBar extends StatefulWidget {
  @override
  _MyTabBarState createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar>
     {
  int _selectedIndex = 0;
  int _selectedTabs = 0;

  TabController? _tabController;

  String? _selectedWaybill;
  String? _selectedProduct;

  final List<String> _waybillOptions = [
    'Waybill 1',
    'Waybill 2',
    'Waybill 3',
  ];

  final List<String> _productOptions = [
    'Product 1',
    'Product 2',
    'Product 3',
  ];

  DateTime? _expiryDate;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2, // Two main tabs: Information and Picture
        child: NestedScrollView(
          headerSliverBuilder: (context, isScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Colors.blueGrey,
                centerTitle: true,
                title: Text('Inventory'),
                bottom: TabBar(
                  labelColor: Colors.white,
                  tabs: [
                    Tab(text: 'Information'),
                    Tab(text: 'Picture'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              DefaultTabController(
                length: 1, // One tab for Information
                child: Scaffold(
                  appBar: TabBar(
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: 'Details'), // Only one tab
                    ],
                  ),
                  body: _informationTab(),
                ),
              ),
              // Picture Tab
              DefaultTabController(
                length: 5, // Five tabs for Picture
                child: Scaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Align tabs to the start
                      children: [
                        Flexible(child: _tabBarForPicture()),
                      ],
                    ),
                  ),
                  body: _buildTabBarViewForPicture(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _informationTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAutocomplete('Waybill', _selectedWaybill, _waybillOptions,
              (value) {
            setState(() {
              _selectedWaybill = value;
            });
          }),
          SizedBox(height: 16),
          _buildAutocomplete('Product', _selectedProduct, _productOptions,
              (value) {
            setState(() {
              _selectedProduct = value;
            });
          }),
          SizedBox(height: 16),
          _buildTextField('Contents per Box'),
          _buildTextField('Contents per Case'),
          _buildTextField('Arrived Quantity per Case'),
          _buildTextField('Arrived Quantity per Box'),
          _buildTextField('Lot No.'),
          _buildDateField('Expiry Date'),
          _buildTextField('Weight (g)'),
          _buildTextField('Length (cm)'),
          _buildTextField('Width (cm)'),
          _buildTextField('Height (cm)'),
        ],
      ),
    );
  }

  Widget _buildAutocomplete(
    String label,
    String? selectedValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(
        text: selectedValue ?? '',
      ),
      optionsBuilder: (TextEditingValue textEditingValue) {
        return options.where((String option) {
          return option
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (String selectedOption) {
        onChanged(selectedOption);
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        textEditingController.text = selectedValue ?? '';
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildTextField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        keyboardType: label.contains('Date')
            ? TextInputType.datetime
            : TextInputType.text,
      ),
    );
  }

  Widget _buildDateField(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(
          text: _expiryDate == null
              ? ''
              : '${_expiryDate!.toLocal()}'.split(' ')[0],
        ),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        onTap: () async {
          DateTime? selectedDate = await showDatePicker(
            context: context,
            initialDate: _expiryDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (selectedDate != null && selectedDate != _expiryDate) {
            setState(() {
              _expiryDate = selectedDate;
            });
          }
        },
      ),
    );
  }

  Widget _tabBarForPicture() {
    return TabBar(
      indicatorWeight: BorderSide.strokeAlignCenter,
      dragStartBehavior: DragStartBehavior.start,
      controller: _tabController,
      labelColor: Colors.black,
      indicatorSize: TabBarIndicatorSize.tab,
      tabAlignment: TabAlignment.start,
      isScrollable: true,
      automaticIndicatorColorAdjustment: true,
      indicator: BoxDecoration(
        color: Colors.blue[900],
        borderRadius: BorderRadius.circular(40),
        backgroundBlendMode: BlendMode.colorBurn,
      ),
      splashBorderRadius: BorderRadius.circular(40),
      tabs: [
        Tab(
          text: 'Top View (Primary)',
          iconMargin: EdgeInsets.zero,
          icon: Icon(Icons.photo_camera_back),
        ),
        Tab(
          text: 'Side View',
          iconMargin: EdgeInsets.zero,
          icon: Icon(Icons.photo_camera_back),
        ),
        Tab(
          text: 'Inside From',
          iconMargin: EdgeInsets.zero,
          icon: Icon(Icons.photo_camera_back),
        ),
        Tab(
          text: 'Inside Back',
          iconMargin: EdgeInsets.zero,
          icon: Icon(Icons.photo_camera_back),
        ),
        Tab(
          text: 'Expiry',
          iconMargin: EdgeInsets.zero,
          icon: Icon(Icons.photo_camera_back),
        ),
      ],
      onTap: (index) {
        setState(() {
          _selectedTabs = index;
        });
      },
    );
  }

  Widget _buildTabBarViewForPicture() {
    return TabBarView(
      children: [
        Center(
          child: CameraWidget(),
        ),
        Center(
          child: CameraWidget1(),
        ),
        Center(
          child: CameraWidget2(),
        ),
        Center(
          child: CameraWidget3(),
        ),
        Center(
          child: CameraWidget4(),
        ),
      ],
    );
  }
}
