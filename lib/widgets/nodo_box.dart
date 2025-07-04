import 'package:flutter/material.dart';

Widget graphRect(int? a, List<Map<String, dynamic>> pesosConColor) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      boxShadow: [BoxShadow(color: Colors.blue[100]!, spreadRadius: 1)],
      color: Colors.white,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Ciudad $a', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          'Costos:',
          style: TextStyle(fontSize: 10, color: Colors.grey[700]),
        ),
        ...pesosConColor.map(
          (item) => Text(
            '→ ${item['peso']}',
            style: TextStyle(fontSize: 12, color: item['color'] as Color),
          ),
        ),
      ],
    ),
  );
}
