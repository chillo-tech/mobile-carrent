import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomModal extends StatefulWidget {
  const BottomModal(
      {Key? key,
      required this.searchList,
      required this.dropdownController,
      required this.label})
      : super(key: key);
  final List<String> searchList;
  final TextEditingController dropdownController;
  final String label;

  @override
  State<BottomModal> createState() => _BottomModalState();
}

class _BottomModalState extends State<BottomModal> {
  String _searchText = '';

  void _handleSearch(String value) {
    setState(() {
      _searchText = value;
    });
  }

  void _setOption(String value) {
    widget.dropdownController.text = value;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> filteredList = widget.searchList.where((element) {
      if (element == null) return false;
      return element.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return SizedBox(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildTextField(),
                  Flexible(
                      child: ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(filteredList[index]),
                        onTap: () => _setOption(filteredList[index]),
                      );
                    },
                  ))
                ])));
  }

  Widget _buildTextField() {
    return TextField(
      onChanged: _handleSearch,
      decoration: InputDecoration(
        prefixIcon: Image.asset(
          'assets/icons/ic_search.png', // Replace with your image path
        ),
        hintText: 'Entrer'.tr + ' ' + widget.label,
        hintStyle: const TextStyle(color: Color(0xFF858381)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }
}
