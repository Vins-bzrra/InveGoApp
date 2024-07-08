import 'package:flutter/material.dart';
import 'package:invego_app/widgets/menu_navigation.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isExpanded;
  final List<String> subItems;

  const MenuItem({
    Key? key,
    required this.title,
    required this.onTap,
    required this.isExpanded,
    required this.subItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            width: double.infinity,
            child: Center(
              child: Text(
                title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ),
        if (isExpanded)
          Column(
            children: subItems
                .map((subItem) => GestureDetector(
                      onTap: () {
                        MenuNavigation.navigate(context, title, subItem);
                      },
                      child: Container(
                        width: double.infinity, 
                        constraints: const BoxConstraints(maxWidth: 200), 
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(vertical: 4), 
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(child: Text(subItem)),
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }
}
