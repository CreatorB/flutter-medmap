import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medmap/cubit/partnership/list/partnership_list_wgt_card.dart';
import 'partnership_list_cubit.dart';

class PartnershipListPage extends StatelessWidget {
  const PartnershipListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partnership List'),
      ),
      body: BlocProvider(
        create: (context) => PartnershipListCubit()..fetchPartnershipLists(context),
        child: BlocBuilder<PartnershipListCubit, PartnershipListState>(
          builder: (context, state) {
            if (state is PartnershipListStateLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PartnershipListStateLoaded) {
              if (state.requests.isEmpty) {
                return const Center(child: Text('No data found'));
              }
              return ListView.builder(
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  return PartnershipListWgtCard(item: state.requests[index]);
                },
              );
            } else if (state is PartnershipListStateError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
    );
  }
}