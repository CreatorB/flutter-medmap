import 'package:flutter/material.dart';
import 'package:medmap/cubit/partnership/list/partnership_detail_page.dart';
import 'package:medmap/cubit/partnership/list/partnership_list_cubit.dart';

class PartnershipListWgtCard extends StatelessWidget {
  final PartnershipListModel item;

  PartnershipListWgtCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PartnershipDetailPage(item: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.medication,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          item.product.name,
                          style: TextStyle(
                            color: Color(0xFF150A33),
                            fontSize: 14,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      (item.companyName.length > 25)
                          ? '${item.companyName.substring(0, 25)}...'
                          : item.companyName,
                      style: TextStyle(
                        color: Color(0xFF150A33),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          item.state.name + ', ',
                          style: TextStyle(
                            color: Color(0xFF514A6B),
                            fontSize: 12,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        Text(
                          item.country.name,
                          style: TextStyle(
                            color: Color(0xFF514A6B),
                            fontSize: 12,
                            fontFamily: 'Open Sans',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
