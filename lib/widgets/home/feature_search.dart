import 'package:flutter/material.dart';

class FeatureSearch extends StatelessWidget {
  final TextEditingController? controller;

  final ValueChanged<String>? onChanged;

  final VoidCallback? onTap;

  final VoidCallback? onManageFeature;

  const FeatureSearch({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.onManageFeature,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /// Search
        Expanded(
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(28),
            color: Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: onTap,
              child: Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: controller,
                        onChanged: onChanged,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: "Cari fitur",
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        /// Atur Fitur
        Material(
          color: Colors.blue.shade50,
          elevation: 2,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: onManageFeature,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Atur Fitur",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
